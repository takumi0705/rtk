class DateStore
  
  constructor:() ->
    @date = gon.list

  date_add:(message) ->
    @date.push(message)
  
  date_push:() ->
    @date

class LocalS
  
  constructor:(key) ->
    if localStorage.getItem(key) isnt null
      @alldate = JSON.parse(localStorage.getItem(key))
      @rescount = @alldate["rescount"]
      @myres = @alldate["myres"]
    else
      @rescount = 0
      @myres = []
  push_storage:(key) ->
    date ={"rescount": "#{@rescount}","myres" : @myres}
    localStorage.setItem(key,JSON.stringify(date))

  pop_storage:(key) ->
    JSON.parse(localStorage.getItem(key))
  
#データ表示成形用
class Output

 output:(message,treeb,akaresb,onlyforme,resforme,myres) =>
  console.log message
  # 受け取ったデータをappend
  tbutton = treeb
  messagebody = @mescape(message.body,message.resnum)

  #共通部品
  newpost = "#{message.new}"
  if(newpost isnt "1")
    newlabel = "<span class='label label-warning' id='newlabel#{message.resnum}'>New</span>"
  else
    newlabel =""
  
  if myres is 1
    myreslabel = "&nbsp;<span class='label label-primary'>あなた</span>"
  else
    myreslabel = ""

  if resforme is 1
    formelabel = "&nbsp;<span class='label label-success'>あなたへ</span>"
  else
    formelabel = ""

  if(akaresb is 'on' or onlyforme is 'on')
    style = "style='display:none;'"
    if resforme is 1 and akaresb isnt 'on'
      style = ""
      $("##{message.resid}").attr style: ""
  else
    style = ""
  

  resnumAtime   = "<div class='head'><span><a name='ank#{message.resnum}'>#{message.resnum}</a>#{myreslabel}#{formelabel}
                   <span class='badge' data-content='' data-title='#{message.resnum}への返信' id='rec#{message.resnum}'></span>
                   <small> #{message.time}</small> #{newlabel}"
  resnumAtimer  = "<div class='head'><span><a name='ank#{message.resnum}'>#{message.resnum}</a>#{myreslabel}#{formelabel}
                   <span class='badge' data-content='' data-title='#{message.resnum}への返信' id='rec#{message.resnum}'></span> 
                   <small> #{message.time}</small> #{newlabel}"
  footerm       = "</span></div>
                   <img id='thum#{message.resnum}' ><p>#{messagebody[0]} </p>
                   <div id='childpm#{message.resnum}'></div>
                   <div id='form#{message.resnum}' class='resform' style='display: none'>
                   <form class='form-horizontal'>
                   <div class='form-group'>
                   <textarea  placeholder ='ここへ入力' wrap='hard' rows='5' id='msgbody#{message.resnum}' class='restext' ></textarea>
                   <button type='button' class='btn btn-default btn-lg btn-block resend' id='#{message.resnum}' >送信</button>
                   </div>
                   </form>
                   </div>
                   <div id='child#{message.resnum}' class='contchild'></div>
                   </div>
                   "
  


  if(tbutton isnt 'off' )
    if(message.resid? isnt true)
     $('#chat').append "<div id='#{message.resnum}' class='contarea'>
                        #{resnumAtime}
                        <a class='res' id='#{message.resnum}'>返信</a>
                        #{footerm}"
    else
     $("div#child#{message.resid}").append "<div id='#{message.resnum}' class='contarea'>
                                       #{resnumAtime}
                                       <a class='res' id='#{message.resnum}'>返信</a>
                                       #{footerm}"
     @resinc($("span#rec#{message.resid}"),messagebody[0],message.resnum,message.time,message.resid,onlyforme)
  else
    if(message.resid? isnt true)
      $('#chat').append "<div #{style} id='#{message.resnum}' class='contarea'>
                         #{resnumAtimer}
                         <a class='res' id='#{message.resnum}'>返信</a>
                         #{footerm}"
    else
     $("#chat").append "<div #{style} id='#{message.resnum}' class='contarea'>
                        #{resnumAtimer}
                        <a class='res' id='#{message.resnum}'>返信</a></span></div>
                        <div><span><a class='resanker' name='#{message.resid}'>>>#{message.resid}</a>
                        #{footerm}"
     @resinc($("span#rec#{message.resid}"),messagebody[0],message.resnum,message.time,message.resid,onlyforme)

  $("div#childpm#{message.resnum}").append "<div class='row'>
                                            <div class ='col-xs-10 col-md-10 col-sm-10'>
                                            <div id='pmrow#{message.resnum}'></div>
                                            </div>
                                            <div class='col-xs-2 col-md-2 col-sm-2'></div>
                                            </div>
                                            "
  
  #大きいサムネイル表示
  if message.imgurl isnt "" and message.imgurl?
    $("img#thum#{message.resnum}").attr src: "#{message.imgurl}", class:"bigthum colgm"
    if $.cookie('autopic') is 'on'
      $('img.bigthum').lazyload()
    else
      $("img#thum#{message.resnum}").lazyload
        event : "over mouseover thouchstart"

  vic = 0

  #gifv,webm以外のサムネイル
  $("a#g#{message.resnum}").each ->
    pmurl = $(this).attr('href')
    vic++
    $("div#pmrow#{message.resnum}").append "<div class='col-md-1 col-xs-1 col-sm-1'>
                                            <a id='gm#{message.resnum}#{vic}'class='gm#{message.resnum} colgm' name='gm#{message.resnum}' href='#{pmurl}'>
                                            <img id='lazy#{message.resnum}'class='lazy' data-original='#{pmurl}' width='80px' height='80px'>
                                            </a>
                                            </div>
                                            "
    if $.cookie('autopic') is 'on'
      $('img.lazy').lazyload()
    else
      $("img#lazy#{message.resnum}").lazyload
        event : "over"
      $("#gm#{message.resnum}#{vic}").on 'mouseover touchstart', ->
        $("img#lazy#{message.resnum}").trigger("over")
    #gifv,webmのサムネイル
  $("a#gw#{message.resnum}").each ->
    pmurl = $(this).attr('href')
    $("div#pmrow#{message.resnum}").append "<div class='col-md-1 col-xs-1 col-sm-1'>
                                            <a class='thumbnail' href='#{pmurl}'>
                                            <img class='movie'>
                                            </a>
                                            </div>
                                            "
    #youtube,vimeo用この3つどうにかしろよ
  $("a#gy#{message.resnum}").each ->
    pmurl = $(this).attr('href')
    $("div#pmrow#{message.resnum}").append "<div class='span1'>
                                            <a id='movie#{message.resnum}' class='thumbnail' href='#{pmurl}'>
                                            <img class='movie'>
                                            </a>
                                            </div>
                                            "


  #Newラベル消去用
  if(newpost isnt "1")
   $("#newlabel#{message.resnum}").on 'inview', (event,isInView,visiblePartX,visiblePartY)->
     if(isInView == false)
      $(this).hide 'slow', ->
       $(this).remove()
  #オートスクロール用
   rfocus = $.cookie('restextfocus')
   autoscl = $.cookie('autoscl')
   treec = $.cookie('tree')
   console.log autoscl
   if rfocus isnt 'on' and autoscl is 'on'
    sclba = $("div##{message.resnum}").offset().top
    sclba = sclba - 100
    if treec is 'on'
      setTimeout ->
       $("html,body").animate({scrollTop:sclba})
      , 3000
    else if treec is 'off'
      $("html,body").animate({scrollTop:sclba})

  return 0
 #エスケープ処理
 mescape: (mbody,mnum) ->
    mbb =  mbody.replace(/&/g, "&amp;")
                .replace(/"/g, "&quot;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/\r\n/g, "<br />")
                .replace(/(\n|\r)/g, "<br />")

    reg1 = /http[s]?\:\/\/[\w\+\$\;\?\.\%\,\!\#\~\*\/\:\@\&\\\=\_\-]+(gifv|webm)/g
    reg2 = /http[s]?\:\/\/[\w\+\$\;\?\.\%\,\!\#\~\*\/\:\@\&\\\=\_\-]+(jpg|jpeg|gif|png|bmp)/g
    reg3 = /https\:\/\/(www\.)?youtu(\.be|be)(\.com)?\/(watch\?v=)?([-\w]{11})/g

    pic  = reg1.test(mbody)
    pic2 = reg2.test(mbody)
    pic3 = reg3.test(mbody)

    mba1 = mbb.replace(/(http[s]?\:\/\/[\w\+\$\;\?\.\%\,\!\#\~\*\/\:\@\&\\\=\_\-]+(gifv|webm))/g,"<a id='gw#{mnum}' href='$1'>$1</a>")
    mba2 = mba1.replace(/(http[s]?\:\/\/[\w\+\$\;\?\.\%\,\!\#\~\*\/\:\@\&\\\=\_\-]+(jpg|jpeg|gif|png|bmp))/g,"<a id='g#{mnum}' href='$1'>$1</a>")
    mba3 = mba2.replace(/(https\:\/\/(www\.)?youtu(\.be|be)(\.com)?\/(watch\?v=)?([-\w]{11}))/g,"<a id='gy#{mnum}' href='$1'>$1</a>")
    if(pic isnt true and pic2 isnt true and pic3 isnt true)
      mba3 = mbb.replace(/(http(s)?:\/\/([\w-]+\.)+[\w-]+(\/[\w- .\/?%&=]*)?)/,"<a href='$1'>$1</a>")
    mba2 = 3
    return [mba3,mba2]

 #返信数とツールチップ用関数 
 resinc: (incnum,mbody,mnum,mtime,resid,onlyforme) ->
  
  #rescount
  
  rescount = parseInt(incnum.text(),0)
  if(isNaN(rescount))
    rescount = 0
  hres = rescount + 1
  if(hres is 1)
    incnum.attr 'class','badge'
  else if(hres > 1 and hres < 3)
    incnum.attr 'class','badge rescouBlo'
    if onlyforme isnt 'on'
      $("div##{resid}").attr 'style',''
  else if(hres > 3)
    incnum.attr 'class','badge rescouRed'
    if onlyforme isnt 'on'
     $("div##{resid}").attr 'style',''
  incnum.text(hres)
  
  #tooltip

  tip = incnum.attr 'data-content'
  tip = tip + "<a href='#ank#{mnum}'>#{mnum}</a>:#{mtime}<br>#{mbody}<br>"
  incnum.attr 'data-content',"#{tip}"
  

class ChatClass
 constructor: (url, useWebsocket) ->
  @tree =  "off"
  @akares = "off"
  @onlyf = "off"
  @datestore = new DateStore()
  @output = new Output()
  @group_id = $('#group_id').text()
  @lstorage = new LocalS(@group_id)
  @dispatcher = new WebSocketRails(url, useWebsocket)
  @channel = @dispatcher.subscribe(@group_id)
  @build = $.cookie("build")
  idy = this
  @bindEvents(idy)
  tree = "off"
  @firstdate(tree)

 firstdate:(tree,akares,onlyforme) =>
  @tree = tree
  @akares = akares
  @onlyf = onlyforme
  if @group_id is @build
    @lstorage.myres[0] = 1
  date = @datestore.date_push()
  count = 0
  for i in date
    o = i.resid
    o = o - 0
    if @lstorage.myres.indexOf(i.resnum) is -1
      @output.output(i,@tree,@akares,@onlyf)
    else if i.resid?  and @lstorage.myres.indexOf(o) isnt -1
      @output.output(i,@tree,@akares,@onlyf,1)
    else 
      @output.output(i,@tree,@akares,@onlyf,0,1)
    count++
  @lstorage.rescount = count
  @lstorage.push_storage(@group_id)

 bindEvents: (idy) =>
# 送信ボタンが押されたらサーバへメッセージを送信
  $('#send').on 'click', @sendMessage
  $('#chat').on 'click','button.resend',{test:idy}, @resendMessage

# サーバーからnew_messageを受け取ったらreceiveMessageを実行
  @channel.bind 'websocket_chat', @receiveMessage
  @dispatcher.bind 'websocket_chat', @receiveMessage
 sendMessage: (event) =>
# サーバ側にsend_messageのイベントを送信
# オブジェクトでデータを指定
  msg_body = $('#msgbody').val()
  group_id = $('#group_id').text()
  @channel.trigger 'websocket_chat', {  body: msg_body , group_id: group_id}
  $('#msgbody').val('')

 resendMessage: (event) ->
  #クリックした要素を参照
  resid = $(this).attr('id')
  msg_body = $("#msgbody#{resid}").val()
  group_id = $('#group_id').text()
  #ChatClassを参照  
  event.data.test.channel.trigger 'websocket_chat', {  body: msg_body , group_id: group_id , resid: resid}
  $("#msgbody#{resid}").val('')

 receiveMessage: (message) =>
  #くらいあんとID 取得
  unless message.first_id?
    @datestore.date_add(message)
    @lstorage.rescount++
    
    l = message.resid
    l = l - 0
    if message.client_id is @client_id
      @lstorage.myres.push(message.resnum)
      @lstorage.push_storage(@group_id)
      @output.output(message,@tree,@akares,@onlyf,0,1)
    else if message.resid?  and @lstorage.myres.indexOf(l) isnt -1
      @output.output(message,@tree,@akares,@onlyf,1)
    else
      @output.output(message,@tree,@akares,@onlyf,0)
    
    if message.client_id is @client_id
      @lstorage.myres.push(message.resnum)
      @lstorage.push_storage(@group_id)
  else
    @client_id = message.first_id

 reset:(id) =>
  console.log id
  $("div#chat").empty()
  switch id
    when 'lnew'
      tree = 'off'
      akares= 'off'
      only = 'off'
      @firstdate(tree,akares,only)
    when 'ltree'
      tree = 'on'
      akares= 'off'
      only = 'off'
      @firstdate(tree,akares,only)

    when 'lrnum'
      tree = 'off'
      akares= 'on'
      only = 'off'
      @firstdate(tree,akares,only)
    
    when 'lforme'
      tree = 'off'
      akares= 'off'
      only = 'on'
      @firstdate(tree,akares,only)


    else
      tree = 'off'
      akares = 'off'
      @firstdate(tree,akares)
      id = 'lnew'
  $(".tnav").attr("class","tnav")
  $("##{id}").attr("class","tnav active")


 $ ->
    #ボタンの状態判断用
  gcid = $('#group_id').text()
  bid = ['autopic','autoscl']
  bid.forEach (item) ->
   if(!$.cookie(item) or $.cookie("nowload") isnt gcid and item isnt "autopic")
    $.cookie(item,'off')
   else if($.cookie(item) isnt 'off' )
     $("##{item}").attr 'class','btn btn-default navbar-btn navbtn active'
   else
     $("##{item}").attr 'class','btn btn-default navbar-btn navbtn'
  
  $.cookie("nowload",gcid)

  $('.navbar-btn').click ->
    $(this).button('toggle')
    cookid = $(this).attr('id')
    if $.cookie(cookid) isnt 'on'
     $.cookie(cookid,'on')
    else
     $.cookie(cookid,'off')
    topicEvents.reset("lnew")
    
  topicEvents = new ChatClass($('#chat').data('uri'), true)

  $('.tnav').on 'click', ->
    id = $(this).attr("id")
    console.log id
    topicEvents.reset(id)

  #res anker animetion 
  $('#chat').on 'click','a.resanker', ->
    resid = $(this).attr('name')
    sclbaa = $("div##{resid}").offset().top
    sclbaa = sclbaa - 100
    $("html,body").animate({scrollTop:sclbaa})

#返信フォーム用
  $('#chat').on 'click','a.res', ->
    resid = $(this).attr('id')
    $("div#form#{resid}").show(250)
    $("#msgbody#{resid}").focus()
  #if textarea focus autoscl off
  $('#chat')
   .on 'focus click','div.resform', ->
     $.cookie('restextfocus','on')
   .on 'blur','div.resform',->
     $.cookie('restextfocus','off')
     setTimeout =>
      $(this).hide(250)
     , 1500
  
  $('textarea#msgbody')
   .on 'focus click','textarea.restext', ->
     $.cookie('restextfocus','on')
   .on 'blur','textarea.restext',->
     $.cookie('restextfocus','off')

  $('#chat').on 'click','a.colgm', ->
    iden = $(this).attr('name')
    idena = $(this).attr('id')
    $("a.#{iden}").colorbox(
     rel:"#{iden}"
     maxWidth:"100%"
     maxHeight:"100%"
    )

  $('#chat').on 'click','img.bigthum', ->
    $(this).colorbox(
      href: $(this).attr 'src'
      maxWidth:"100%"
      maxHeight:"100%"
    )

  $(document).popover(
    html: true,
    selector:'.badge',
    content: ->
      $(this).attr('data-content')
  )

