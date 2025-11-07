<%*
let title = tp.file.title

// when the title is `Untitled`, prompt for a new one
if (title.startsWith("Untitled")) {
  title = await tp.system.prompt("Enter a page title") ?? "Untitled";
  await tp.file.rename(`${title}`);
}
-%>
<% tp.file.include("[[frontmatter]]") %>
# <% title %>

