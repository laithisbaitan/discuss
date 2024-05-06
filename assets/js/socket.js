// Bring in Phoenix channels client library:
import {Socket} from "phoenix"

// And connect to the path in "lib/discuss_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.
let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()

const createSocket = (topicId) => {
  let channel = socket.channel(`comments:${topicId}`, {})
  channel.join()
    .receive("ok", resp => { console.log(resp.comments), renderComments(resp.comments) })
    .receive("error", resp => { console.log("Unable to join", resp) })
  
  channel.on(`comments:${topicId}:new`, renderComment);

  document.getElementById('add_btn').addEventListener('click', () => {
    const content = document.getElementById('textarea').value;

    channel.push('comment:add', {content: content});
  });
}

function renderComments(comments){
  const renderedComments = comments.map(comment => {
    return commentTemplate(comment)
  });
  document.getElementById("comments_list").innerHTML = renderedComments.join('');
}

function renderComment(event){
  const renderedComment = commentTemplate(event.comment);

  document.getElementById("comments_list").innerHTML += renderedComment;
}

function commentTemplate(comment){
  let email = 'Anonymous';
  if(comment.user){
    email=comment.user.email;
  }
  return `
  <li class="collection-item">
    ${comment.content}
    <div class="secondary-content">
      ${email}
    </div>
  </li>
`;
}

window.createSocket = createSocket;
// export default socket
