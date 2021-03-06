<?php

header('Content-type: application/json');

require_once "../../config/database.php";
require_once "../../model/Playlist.php";
require_once "../../controller/PlaylistController.php";

if (isset($_POST["update"]) && !empty($_POST["update"]))
{
    //database connection
    $db = connect();

    //model and controller calls
    $playlist = new Playlist($db);
    $playlistController = new PlaylistController($playlist);

    //controller function to push the right data
    print $playlistController->update();
}

?>