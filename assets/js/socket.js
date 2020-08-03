import {Socket, Presence} from "phoenix"

let socket = new Socket("/socket", {
  params: {
    token: window.userToken
  }
})

let roomId    = window.roomId
let presences = {}

socket.connect()

if (roomId) {
  const timeout = 1000
  var typingTimer
  let userTyping = false
  let channel = socket.channel(`room:${roomId}`, {})

  channel.join()
    .receive("ok", resp => {
      console.log("Joined successfully", resp)
      resp.messages.reverse().map(msg => displayMessage(msg))
      scrollToBottom()
    })
    .receive("error", resp => {
      console.log("Unable to join", resp)
    })

  channel.on(`room:${roomId}:new_message`, (message) => {
    displayMessage(message)
    scrollToBottom()
  })

  channel.on("presence_state", state => {
    presences = Presence.syncState(presences, state)
    displayUsers(presences)
    scrollToBottom()
  })

  channel.on("presence_diff", diff => {
    presences = Presence.syncDiff(presences, diff)
    displayUsers(presences)
    scrollToBottom()
  })

  document.querySelector('#message-form').addEventListener('submit', (e) => {
    e.preventDefault()
    let input = e.target.querySelector('#message-body')

    channel.push('message:add', {
      message: input.value
    })

    input.value = ''
  })

  document.querySelector('#message-body').addEventListener('keydown', () => {
    userStartsTyping()
    clearTimeout(typingTimer)
  })

  document.querySelector('#message-body').addEventListener('keyup', () => {
    clearTimeout(typingTimer)
    typingTimer = setTimeout(userStopTyping, timeout)
  })

  const userStartsTyping = () => {
    if(userTyping) {
      return
    }

    userTyping = true
    channel.push('user:typing', {
      typing: true
    })
  }

  const userStopTyping = () => {
    clearTimeout(typingTimer)
    userTyping = false

    channel.push('user:typing', {
      typing: false
    })
  }

  const displayMessage = (msg) => {
    let username = window.username
    let messageClass = username == msg.user.username ? 'user' : 'other'

    let template = `
      <li class="list-group-item message message__${messageClass}">
        <p class="username">${msg.user.username}</p>
        <div class="text">
          <p class="message-text">${msg.body}</p>
          <p class="date">${msg.date}</p>
        </div>
      </li>
    `

    document.querySelector('#display').innerHTML += template
  }

  const displayUsers = (presences) => {
    let usersOnline = Presence.list(presences, (_id, {
      metas: [
        user, ...rest
      ]
    }) => {
      var typingTemplate = ''
      if (user.typing) {
        typingTemplate = '<i>Typing ...</i>'
      }
      return `
        <div id="user-${user.user_id}"><strong class="text-secondary">${user.username}</strong>${typingTemplate}</div>
      `
    }).join("")

    document.querySelector("#users-online").innerHTML = usersOnline
  }

  function scrollToBottom() {
    var objDiv = document.getElementById("display");
    objDiv.scrollTop = objDiv.scrollHeight;
  }
}

export default socket
