
/*********

mirrors_jp_func.js

mirrors_jp.html 40版用 2004.03.09 chado

*********/

// define cr
var cr = '\n';
if (navigator.platform == "MacPPC") { cr = "\r"; } 
else if (navigator.platform == "Win32") { cr = "\r\n"; }

var directory_strings = '';
var twin;
var site_check = false; // for site check

function write_initial_list() {
	var called_uri = this.window.location.href;
	var arg_offset = called_uri.indexOf('?');
	if (arg_offset != -1) { 
		directory_strings = called_uri.substr(arg_offset + 1);
	} else {
		directory_strings = '';
	}
	if (directory_strings == 'direct_list') {
		this.document.write(make_direct_list());
	} else {
		this.document.write(make_links_list());
	}
	return false;
} // end of func write_initial_list()


function make_links_list() {
	var list_html = '';
	if (directory_strings != '') {
		list_html += '<strong>ディレクトリ: ' + directory_strings + '<\/strong>' + cr;
	}
	list_html += '<ul>' + cr;
	var mirrore = new Array;
	for (var list_id = 0; list_id < mirrors.length; list_id++) {
		if (mirrors[list_id] == '-') {
			list_html += '  <li>-------------------<\/li>' + cr;
		} else { 
			list_html += '  <li><a href="' + mirrors[list_id] + directory_strings + '">';
			list_html += mirrors[list_id] + directory_strings + '<\/a><\/li>' + cr;
		}
	}
	list_html += '<\/ul>' + cr;
	return list_html;
} // end of func make_links_list()


function make_direct_list() {
	var list_html = '';
	list_html += '<strong>プリセットディレクトリ:<\/strong>' + cr;
	list_html += '<ul>' + cr;
	var mdire = new Array;
	for (var list_id = 0; list_id < mdirs.length; list_id++) {
		mdire = mdirs[list_id].split('::', 2);
		list_html += '  <li><a href="mirrors_jp.html?' + mdire[1] + '">';
		list_html += mdire[0] + '<\/a><\/li>' + cr;
	}
	list_html += '<\/ul>' + cr;
	return list_html;
} // end of func make_direct_list()


function open_target_win(scheck) {
  site_check = scheck;
	  twin = window.open("","jp_mirros","resizable,menubar=yes,toolbar=yes,location=yes,directories=yes,status=yes");
	  var entire_html = make_upper_html();
	  if (site_check) {
		  entire_html += 'ミラーサイトを選択して [ディレクトリ表示] ボタンをクリックすると';
		  entire_html += ' ここに ディレクトリ一覧が表示されるハズです。';
		} else {
		  entire_html += 'ディレクトリを選択して [ミラーリスト表示] ボタンをクリックすると';
		  entire_html += ' ここに ミラーリストが表示されるハズです。';
		}
	  entire_html += make_lower_html();
	  twin.document.open();
	  twin.document.write(entire_html);
	  twin.document.close();
	  twin.focus();
} // end of func open_target_win()


function make_direct_options() {
	var direct_options = '';
	var mdire = new Array;
	for (var ops_id = 0; ops_id < mdirs.length; ops_id++) {
		mdire = mdirs[ops_id].split('::', 2);
		direct_options += '    <OPTION VALUE="';
		direct_options += mdire[1] + '">' + mdire[0] + cr;
	}
	return direct_options;
} // end of func make_direct_options()


function make_upper_html() {
	var upper_html = '';
	upper_html += '<html>' + cr + '<head>' + cr;
	upper_html += '<meta http-equiv="Content-Type" content="text/html\; charset=EUC-JP">' + cr;
	upper_html += '<title>ftp.mozilla.org - jp mirror + directory<\/title>' + cr;
	upper_html += '<LINK REL="stylesheet" HREF="css/default.css" TYPE="text/css">' + cr;
	upper_html += '<LINK REL="icon" HREF="images/mozilla-16.png" TYPE="image/png">' + cr;
	upper_html += '<style type="text/css">body { margin: 10px; }<\/style>';
	upper_html += '<\/head>' + cr + '<body>' + cr;
	upper_html += '<h2>ftp.mozilla.org - jp mirror + directory<\/h2>' + cr;
	upper_html += '<FORM NAME="direct_f">' + cr;
	if (site_check) { upper_html += 'サイト'; } 
	else { upper_html += 'ディレクトリ'; }
	upper_html += '  <INPUT TYPE="text" NAME="direct_path" SIZE="60" VALUE="">' + cr;
	upper_html += '  <INPUT TYPE="button" VALUE="消去"';
	upper_html += ' OnClick="document.direct_f.direct_path.value = \'\'\;';
	upper_html += ' document.direct_f.direct_path.focus()\;">\&nbsp\;\&nbsp\;' + cr;
	upper_html += '  <BR>' + cr;
	upper_html += '  <SELECT NAME="direct_sel" OnChange="opener.put_direct_sel()">' + cr;
	upper_html += '    <OPTION VALUE=false SELECTED>プリセット' + cr;
	if (site_check) { upper_html += make_site_options(); }
	else { upper_html += make_direct_options(); }
	upper_html += '  <\/SELECT>\&nbsp\;\&nbsp\;\&nbsp\;' + cr;
	if (site_check) { upper_html += '  <INPUT TYPE="button" VALUE="ディレクトリ表示"'; }
	else { upper_html += '  <INPUT TYPE="button" VALUE="ミラーリスト表示"'; }
	upper_html += ' OnClick="opener.display_direct_list()\;">' + cr;
	upper_html += '<\/FORM>' + cr;
	upper_html += '<HR>' + cr;
	return upper_html;
} // end of func make_upper_html()


function make_mid_html() {
	var mid_html = '';
	directory_strings = twin.document.direct_f.direct_path.value;
	if (site_check) {
		mid_html = make_check_list();
	} else {
		mid_html = make_links_list('');
	}
	return mid_html;
} // end of func make_mid_html()


function make_lower_html() {
	var lower_html = '';
	lower_html += '<HR>' + cr;
//	lower_html += '<div class="documentinfo" align="right">' + cr;
	lower_html += '<div class="comment" align="right">' + cr;
	lower_html += 'scripted by うらもじら' + cr;
	lower_html += '<\/div>' + cr;
	lower_html += '<\/body>' + cr + '<\/html>' + cr;
	return lower_html;
} // end of func make_lower_html()


function put_direct_sel() {
	var twd = twin.document;
	var selected_value = twd.direct_f.direct_sel.options[twd.direct_f.direct_sel.selectedIndex].value;
	if (selected_value) { // if not zero
		twd.direct_f.direct_path.value = selected_value;
	}
	return false;
} // end of func put_direct_sel()


function display_direct_list() {
	  var entire_html = make_upper_html() + make_mid_html() + make_lower_html();
	  twin.document.open();
	  twin.document.write(entire_html);
	  twin.document.close();
} // end of func display_direct_list()


function put_switch_link() {
	if (directory_strings == 'direct_list') { 
		this.document.writeln('<a href="mirrors_jp.html">ミラーサイト リスト<\/a><br><br>');
	} else {
		this.document.writeln('<a href="mirrors_jp.html?direct_list">プリセットディレクトリ<\/a><br><br>');
	}
	return false;
} // end of func put_switch_link()


function make_site_options() {
	var site_options = '';
	for (var ops_id = 0; ops_id < mirrors.length; ops_id++) {
		if (mirrors[ops_id] != '-') {
			site_options += '    <OPTION VALUE="';
			site_options += mirrors[ops_id] + '">' + mirrors[ops_id] + cr;
		}
	}
	return site_options;
} // end of func make_site_options()


function make_check_list() {
	var list_html = '';
	if (directory_strings != '') {
		list_html += '<strong>ミラーサイト: ' + directory_strings + '<\/strong>' + cr;
	}
	list_html += '<ul>' + cr;
	var mdire = new Array;
	for (var list_id = 0; list_id < mdirs.length; list_id++) {
		mdire = mdirs[list_id].split('::', 2)
		list_html += '  <li><a href="' + directory_strings + mdire[1] + '">';
		list_html += mdire[0] + '<\/a><\/li>' + cr;
	}
	list_html += '<\/ul>' + cr;
	return list_html;
} // end of func make_check_list()

