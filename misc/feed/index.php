<?php 

$content = file_get_contents("http://www.bistudio.com/newsfeed/arma3_news.php?build=main&language=" . $_GET["language"]); 
$encoding = 'UTF-8';
if ($_GET["language"] == 'Russian') {
	$encoding = 'UTF-16LE';
};
$content = iconv($in_charset = $encoding, $out_charset = 'UTF-8' , $content);
$content = str_replace("</body>", '<h2>Task Force Arrowhead Radio</h2><p>Thanks for using TFAR!</p><p><a href="http://radio.task-force.ru/en">TFAR page</a></p></body>', $content);

print $content;


?>