<?php


$files = glob('*.sqf');

foreach ($files as $file) {
	rename($file, str_replace('fn_', 'fnc_', $file));
}
