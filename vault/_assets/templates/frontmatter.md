<% "---" %>
<%*
let createDate = moment(tp.file.creation_date("YYYY-MM-DDTHH:mm:ssZ"));
let modifyDate = moment(tp.file.last_modified_date("YYYY-MM-DDTHH:mm:ssZ"));
let date = moment.min(createDate, modifyDate);
-%>
type: note
created: <% date.format("YYYY-MM-DDTHH:mm:ssZ") %>
updated: <% tp.date.now("YYYY-MM-DDTHH:mm:ssZ") %>
tags: []
aliases: []
<% "---" %>