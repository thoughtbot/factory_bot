<%*
// @file prompts for a Regular Expression and renders a list of files with 
// filenames that match that Regex

let dv = app.plugins.plugins["dataview"].api;

// prompt user for regex query string
let regex = await tp.system.prompt("Regex");

if (regex) {
  // filter results
  const results = dv.pages()
    .where((page) => page.file.name.search(RegExp(regex)) !== -1)
    .sort((file) => file.path, "asc");
  
  // print out the shortest path 
  // (makes an assumption that all note names are unique in the vault)
  list = results.map(i => `- [[${i.file.name}]]`).join('\n')
  
  tR += list;
}
%>
