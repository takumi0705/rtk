WebsocketRails::EventMap.describe do

  subscribe :client_connected, to: WebsocketChatController,
  with_method: :connect_user
  # websocket_chatイベントのマッピング

  subscribe :client_disconnected, to: WebsocketChatController,
  with_method: :exit
  
  subscribe :websocket_chat, to: WebsocketChatController,
  with_method: :new_message

  subscribe :leave, to: WebsocketChatController,
  with_method: :leave

  subscribe :in, to: WebsocketChatController,
  with_method: :in
end

