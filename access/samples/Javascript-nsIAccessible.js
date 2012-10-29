/*
 * Javascript-nsIAccessible.js
 */

var accNode = null;

function setupListeners(iframe)
{
  netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
  iframe.contentDocument.addEventListener("focus",testFocus,false); 
  iframe.contentDocument.addEventListener("click",testClicks,false); 
  iframe.contentDocument.addEventListener("mouseover",testMouseOver,false); 
};

function testDOMNode(domNode)
{
  var accService = null;
  accNode = null;

  netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");

  try {
    var accService = Components.classes["@mozilla.org/accessibilityService;1"].createInstance();
    accService = accService.QueryInterface(Components.interfaces.nsIAccessibilityService);
  }
  catch (ex) { dump ("\nError getting accessibility service\n");}

  if (!accService)
    return;
   
  try {
    accNode = accService.getAccessibleFor(domNode);
  } catch(ex) { }
  updateDisplay();
};

function navigateToParent()
{
  netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
  accNode = accNode.parent;
  updateDisplay();
};

function navigateToPreviousSibling()
{
  netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
  accNode = accNode.previousSibling;
  updateDisplay();
};

function navigateToNextSibling()
{
  netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
  accNode = accNode.nextSibling;
  updateDisplay();
};

function navigateToFirstChild()
{
  netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
  accNode = accNode.firstChild;
  updateDisplay();
};

function navigateToLastChild()
{
  netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
  accNode = accNode.lastChild;
  updateDisplay();
};

const stateDesc = [
  "unavailable",
  "selected",
  "focused",
  "pressed",
  "checked",
  "mixed",
  "readonly",
  "hottracked",
  "default",
  "expanded",
  "collapsed",
  "busy",
  "floating",
  "marqueed",
  "animated",
  "invisible",
  "offscreen",
  "sizeable",
  "moveable",
  "selfvoicing",
  "focusable",
  "selectable",
  "linked",
  "traversed",
  "multiselectable",
  "extselectable",
  "alert_low",
  "alert_medium",
  "alert_high",
  "protected",
  "haspopup"
];

function stateToString(accNode)
{
  var state = accNode.state;
  var stateStr = "";
  var states = new Array();
  var i;
  for (i = 0; i < stateDesc.length; i++) {
    if (state & (1 << i)) {
      states.push(stateDesc[i]);
    }
  }
  if (states.length) {
    stateStr = " ( " + states.join(" | ") + " ) ";
  }
  return stateStr;
}

/* Taken from nsProgressDlg.js */
function hex(num)
{
  return "0x" + ("0000000" + Number(num).toString(16)).slice(-8);
}

function updateDisplay()
{
  netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
  var infoPanel = document.getElementById("infopanel");
  var warnPanel = document.getElementById("warnpanel");
  if (!accNode) {
    infoPanel.setAttribute("class", "hidden");
    warnPanel.setAttribute("class", "visible");
    return;
  }
    
  infoPanel.setAttribute("class", "visible");
  warnPanel.setAttribute("class", "hidden");
  try { document.getElementById("role").firstChild.nodeValue = accNode.role; } catch(ex) {}
  try { document.getElementById("name").firstChild.nodeValue = accNode.name; } catch(ex) {}
  try { document.getElementById("value").firstChild.nodeValue = accNode.value; } catch(ex) {}
  try {
    var stateStr = hex(accNode.state) + stateToString(accNode);
    document.getElementById("state").firstChild.nodeValue = stateStr;
  } catch(ex) {}
};

function testFocus(evt)
{
  if (!document.getElementById("track-focus").checked)
    return;  // Test focus option is off
    
  testDOMNode(evt.target);
};

function testClicks(evt)
{
  if (!document.getElementById("track-clicks").checked)
    return;  // Test clicks option is off

  testDOMNode(evt.target);
};

function testMouseOver(evt)
{
  if (!document.getElementById("track-mouseover").checked)
    return;  // Test clicks option is off

  testDOMNode(evt.target);
};
