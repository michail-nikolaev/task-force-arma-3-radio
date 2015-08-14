<?php 

<<<<<<< HEAD
error_reporting(-1);
ini_set('display_errors', 'On');

$content = file_get_contents("http://www.bistudio.com/newsfeed/arma3_news.php?build=main&language=" . $_GET["language"]); 
$encoding = 'UTF-8';
/*if ($_GET["language"] == 'Russian') {
	$encoding = 'UTF-16LE';
};*/
$content = iconv($in_charset = $encoding, $out_charset = 'UTF-8' , $content);
$content = str_replace('<body>', '<body><h1><br>Please support <b>Task Force Arrowhead Radio</b> on <a href="http://makearmanotwar.com/entry/pMP8c7vSS4#.VAyzWPnV9UA">MAKE ARMA NOT WAR</a>! Thanks! </h1>', $content);

print $content;

$File = "counter" . date("z")  . ".txt"; 

$handle = fopen($File, 'c+'); 
if (flock($handle, LOCK_EX )) {	
	$data = file_get_contents($File);	
	$count = $data + 1;
	
	ftruncate($handle, 0);
	fwrite($handle, $count);
	
	flock($handle, LOCK_UN);
	fclose($handle);
} else {
	exit(1);
};
=======
$content = file_get_contents("http://www.bistudio.com/newsfeed/arma3_news.php?build=main&language=" . $_GET["language"]); 
$encoding = 'UTF-8';
if ($_GET["language"] == 'Russian') {
	$encoding = 'UTF-16LE';
};
$content = iconv($in_charset = $encoding, $out_charset = 'UTF-8' , $content);
$content = str_replace("</body>", '<h2>Task Force Arrowhead Radio</h2><p>Thanks for using TFAR!</p><p><a href="http://radio.task-force.ru/en">TFAR page</a></p></body>', $content);

print $content;

>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086

?>