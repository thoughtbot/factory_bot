<%*
// prompt user for a title
let title = await tp.system.prompt("Note Name", `Untitled`, false, true);
if (title == null) return;
if (tp.file.find_tfile(title)) return;

title = title.trim();
console.log('title', title);

// determine the current parent folder
let parentPath = tp.file.folder(true);
let folder = app.vault.getAbstractFileByPath(parentPath);
if (folder == null) throw new Error('folder not found');
console.log('parent path', parentPath);

// see if a note with that title already exists
const files = app.vault.getFiles(); 
let child = files.find(file => file.basename === title);

let parent_data = {
  test: 'hello world',
};

// if child note doesn't already exist, create it
if (!child) {
  // retrieve the contents of a template
  let template = await tp.file.find_tfile("default template");
  let content = await app.vault.read(template);

  // inject data into the top of the template
  content = `\<\%\* const parent_data = ${JSON.stringify(parent_data)}; \-\%\>` + content;
  console.log('content', content);

  // generate note using a template content
  child = await tp.file.create_new(content, title, false, folder);
}
console.log('child', child);

// generate and append an internal link to the note
tR += app.fileManager.generateMarkdownLink(child, tp.file.folder(true));

// and open the child file
app.workspace.getLeaf(true).openFile(child);
%>
