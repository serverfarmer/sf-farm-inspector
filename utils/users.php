#!/usr/bin/php
<?php
// Analyze /etc/passwd and /etc/group files, and print out set of commands
// creating all found users and groups, along with their directories and
// synchronizing data.
// Tomasz Klim, Aug 2014, Feb 2016


$minuid = 1001;
$maxuid = 65500;

$mingid = 1001;
$required_groups = array();

if ($argc < 6)
	die("usage: php users.php <hostname> <target> <port> <user> <key>\n");

$hostname = $argv[1];  // local mode if empty
$target = $argv[2];
$port = ( is_numeric($argv[3]) ? intval($argv[3]) : 22 );
$user = $argv[4];
$sshkey = $argv[5];

// end of configuration, now functions

function readdb($file, $hostname, $port, $user, $sshkey) {
	if (empty($hostname))
		return file_get_contents($file);
	else {
		$command = "ssh -i $sshkey -p $port -o StrictHostKeyChecking=no $user@$hostname \"cat $file\"";
		return shell_exec($command);
	}
}

// end of functions, now gathering data

$data = readdb("/etc/group", $hostname, $port, $user, $sshkey);
$lines = explode("\n", $data);
$groups = array();

foreach ($lines as $line) {
	if (empty($line)) continue;
	$fields = explode(":", $line);
	$groups[$fields[2]] = array(
		"group"        => $fields[0],
		"gid"          => $fields[2],
		"supplemental" => empty($fields[3]) ? array() : explode(",", $fields[3]),
	);
}

$data = readdb("/etc/passwd", $hostname, $port, $user, $sshkey);
$lines = explode("\n", $data);
$users = array();

foreach ($lines as $line) {
	if (empty($line)) continue;
	$fields = explode(":", $line);
	$login = $fields[0];
	$uid = $fields[2];
	$gid = $fields[3];
	if ($uid >= $minuid && $uid <= $maxuid) {
		$users[$login] = array(
			"login" => $login,
			"group" => $groups[$gid]["group"],
			"uid"   => $uid,
			"gid"   => $gid,
			"gecos" => $fields[4],
			"home"  => $fields[5],
			"shell" => $fields[6],
		);
		if ($uid == $gid && $fields[0] == $groups[$gid]["group"])
			$users[$login]["usergroup"] = true;
		else if ($gid >= $mingid)
			$required_groups[$gid] = $groups[$gid]["group"];
	}
}

// end of gathering data, now print out the commands

foreach ($required_groups as $gid => $group)
	echo "groupadd -g $gid $group\n";

if (!empty($required_groups))
	echo "\n";

foreach ($users as $login => $data) {
	$uidgid = $data["uid"];
	$cmd = "useradd -s " . $data["shell"];

	if (empty($data["usergroup"]))
		$cmd .= " -g " . $data["group"];
	else {
		echo "groupadd -g $uidgid $login\n";
		$cmd .= " -g $login";
	}

	$cmd .= " -u $uidgid";

	if (!empty($data["gecos"]))
		$cmd .= " -c \"" . $data["gecos"] . "\"";

	if (strpos($data["home"], "/srv/") === 0)
		$cmd .= " -m -d " . $data["home"];
	else if (strpos($data["home"], "/home/") === 0)
		$cmd .= " -m";
	else
		$cmd .= " -M";

	$cmd .= " $login";
	echo "$cmd\n";
}

echo "\n";
foreach ($groups as $gid => $data) {
	if (!empty($data["supplemental"])) {
		$group = $data["group"];
		foreach ($data["supplemental"] as $login)
			if (isset($users[$login]))
				echo "usermod -G $group -a $login\n";
	}
}

echo "\n";
foreach ($users as $login => $data)
	if (strpos($login, "smb-") === 0)
		echo "smbpasswd -a $login\n";

echo "\n";
foreach ($users as $login => $data)
	if (strpos($login, "smb-") === false && strpos($login, "rsync-") === false && strpos($login, "sshfs-") === false && $login != "motion")
		echo "passwd $login\n";

echo "\n";
foreach ($users as $login => $data) {
	if (strpos($data["home"], "/srv/") === 0) {
		$home = $data["home"];
		$parent = dirname($home);
		echo "rsync -e \"ssh -i /etc/local/.ssh/key-$target\" -av $home $target:$parent\n";
	}
}
