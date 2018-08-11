// FitSM scripts
var fs = require("fs");
console.log("\n *START* \n");
var content = fs.readFileSync('data/fitsm-0-terms-and-definitions.json');
console.log("Output Content : \n"+ content);
console.log("\n *EXIT* \n");