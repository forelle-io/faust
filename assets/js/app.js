// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"
import "jquery/dist/jquery";
import "popper.js";
import "bootstrap/dist/js/bootstrap";
import "bootstrap-select/dist/js/bootstrap-select";
import Croppr from "croppr/dist/croppr";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
import {socket, Presence} from "./socket"

window.socket = socket
window.Presence = Presence
window.Croppr = Croppr