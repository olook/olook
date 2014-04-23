// Fix console.log with IE9. 

if (!window.console) window.console = {};
if (!window.console.log) window.console.log = function () { };