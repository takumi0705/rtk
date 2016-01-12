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
    date ={"rescount": @rescount,"myres" : @myres}
    localStorage.setItem(key,JSON.stringify(date))

  pop_storage:(key) ->
    JSON.parse(localStorage.getItem(key))
  
#データ表示成形用
class Output

 output:(newpost,resnum,message,treeb,akaresb,onlyforme,resforme,myres) =>
  resnum++
  console.log message
  # 受け取ったデータをappend
  tbutton = treeb
  messagebody = @mescape(message.body,resnum,message.comment_id)
  #共通部品
  #本文アンカーが自分のレスに対してなら
  if messagebody[2] is 1
    resforme = 1

  if(newpost is "on")
    newlabel = "<span class='label label-warning' id='newlabel#{resnum}'>New</span>"
  else
    newlabel =""
  
  if myres is 1
    myreslabel = "blue"
    formelabel = ""
  else if resforme is 1
    formelabel = "green"
    myreslabel = ""
  else
    formelabel = ""
    myreslabel = "white"
   
  if(akaresb is 'on' or onlyforme is 'on')
    style = "style='display:none;'"
    if resforme is 1 and akaresb isnt 'on'
      style = ""
      $("##{message.resid}").attr style: ""
  else
    style = ""
  
  if sessionStorage.getItem(message.client_id) is 'on'
    ngstyle = "display:none;"
  else
    ngstyle = ""

  hyou = "<button class='btn btn-default btn-xs nguser' data-cid='#{message.client_id}'>NG</button>"


  resnumAtime   = "<div class='head'><div class='anker'>
                   <a class='anker'  name='ank#{message.comment_id}'>#{resnum}</a>
                   <span class='badge' data-content='' data-title='#{resnum}への返信' id='rec#{message.comment_id}'></span>
                   </div>
                   <small> #{message.time}</small> #{newlabel} #{hyou}"
  resnumAtimer  = "<div class='head'>
                   <div class='anker'>
                   <a class='anker' name='ank#{message.comment_id}'>#{resnum}</a>
                   </div>
                   <span class='badge' data-content='' data-title='#{resnum}への返信' id='rec#{message.comment_id}'></span> 
                   <small> #{message.time}</small> #{newlabel} #{hyou}"
  footerm       = "</span></div>
                   <div class='m#{message.client_id}' style='#{ngstyle}'> 
                   <img id='thum#{resnum}' style='display:none;' ><p class='word'>#{messagebody[0]} </p>
                   </div>
                   <div id='childpm#{resnum}' class='m#{message.client_id}' style='#{ngstyle}'></div>
                   <div id='child#{message.comment_id}' class='contchild'></div>
                   </div>
                   "


  if(tbutton isnt 'off' )
    if(message.resid? isnt true)
     $('#chat').append "<div id='#{message.comment_id}' class='contarea  #{myreslabel} #{formelabel}'>
                        #{resnumAtime}
                        <a class='res' id='#{message.comment_id}'>返信</a>
                        #{footerm}"
    else
     $("div#child#{message.resid}").append "<div id='#{message.comment_id}' class='contarea  #{myreslabel} #{formelabel} rescont'>
                                       #{resnumAtime}
                                       <a class='res' id='#{message.comment_id}'>返信</a>
                                       #{footerm}"
     @resinc($("span#rec#{message.resid}"),messagebody[0],resnum,message.time,message.resid,onlyforme)
  else
    if(message.resid? isnt true)
      $('#chat').append "<div #{style} id='#{message.comment_id}' class='contarea  #{myreslabel} #{formelabel}'>
                         #{resnumAtimer}
                         <a class='res' id='#{message.comment_id}'>返信</a>
                         #{footerm}"
    else
     anknum = $("a[name='ank#{message.resid}']").text()
     $("#chat").append "<div #{style} id='#{message.comment_id}' class='contarea  #{myreslabel} #{formelabel}'>
                        #{resnumAtimer}
                        <a class='res' id='#{message.comment_id}'>返信</a></div>
                        <div class='m#{message.client_id}'><span><a class='resanker' name='#{message.resid}'>>>#{anknum}</a>
                        #{footerm}"
     @resinc($("span#rec#{message.resid}"),messagebody[0],resnum,message.time,message.resid,onlyforme)

  $("div#childpm#{resnum}").append "<div class='row'>
                                            <div class ='col-xs-10 col-md-10 col-sm-10'>
                                            <div id='pmrow#{resnum}'></div>
                                            </div>
                                            <div class='col-xs-2 col-md-2 col-sm-2'></div>
                                            </div>
                                            "
  
  #大きいサムネイル表示
  if message.imgurl isnt "" and message.imgurl?
    $("img#thum#{resnum}").attr style: ""
    $("img#thum#{resnum}").attr 'data-original',"#{message.imgurl}"
    $("img#thum#{resnum}").attr class: "bigthum colgm"
    if $.cookie('autopic') is 'on'
      $('img.bigthum').lazyload()
    else
      $("img#thum#{resnum}").lazyload
        event : "over mouseover thouchstart"
    
  vic = 0

  #gifv,webm以外のサムネイル
  $("a#g#{resnum}").each ->
    pmurl = $(this).attr('href')
    vic++
    
    $("div#pmrow#{resnum}").append "<div class='col-md-1 col-xs-1 col-sm-1'>
                                            <a id='gm#{resnum}#{vic}'class='gm#{resnum} colgm' name='gm#{resnum}' href='#{pmurl}'>
                                            <img id='lazy#{resnum}'class='lazy' data-original='#{pmurl}' width='80px' height='80px'>
                                            <span id='hide#{resnum}' style='display:none;'></span>
                                            </a>
                                            </div>
                                            "
    if $.cookie('autopic') is 'on'
      $("img#lazy#{resnum}").lazyload
         appear : ->
          console.log "aoiaoi"
          pic = $("img#lazy#{resnum}")
          hide = $("span#hide#{resnum}")
          setTimeout ->
            hideurl = hide.text()
            picurl = pic.attr("data-original")
            if hideurl isnt picurl
             stop()
          , 8000
        load : (elements_left)->
          hide = $("span#hide#{resnum}")
          if elements_left is 0
            hide.text("#{pmurl}")
    else
      $("img#lazy#{resnum}").lazyload
        appear : ->
          console.log "aoiaoi"
          pic = $("img#lazy#{resnum}")
          hide = $("span#hide#{resnum}")
          setTimeout ->
            hideurl = hide.text()
            picurl = pic.attr("data-original")
            if hideurl isnt picurl
             stop()
             hide.text("停止")
          , 8000
        load : (elements_left)->
          hide = $("span#hide#{resnum}")
          if elements_left is 0
            hide.text("#{pmurl}")
        event : "over"
      $("#gm#{resnum}#{vic}").on 'mouseover touchstart', ->
        $("img#lazy#{resnum}").trigger("over")
    
    #gifv,webmのサムネイル
  $("a#gw#{resnum}").each ->
    pmurl = $(this).attr('href')
    $("div#pmrow#{resnum}").append "<div class='col-md-1 col-xs-1 col-sm-1'>
                                            <a class='thumbnail' href='#{pmurl}'>
                                            <img class='movie'>
                                            </a>
                                            </div>
                                            "
    #youtube,vimeo用この3つどうにかしろよ
  $("a#gy#{resnum}").each ->
    pmurl = $(this).attr('href')
    $("div#pmrow#{resnum}").append "<div class='span1'>
                                            <a id='movie#{resnum}' class='thumbnail' href='#{pmurl}'>
                                            <img class='movie'>
                                            </a>
                                            </div>
                                            "
   #Newラベル消去用
  if(newpost is "on")
   $("#newlabel#{resnum}").on 'inview', (event,isInView,visiblePartX,visiblePartY)->
     if(isInView == false)
      $(this).hide 'slow', ->
       $(this).remove()
  #オートスクロール用
   rfocus = $.cookie('restextfocus')
   autoscl = sessionStorage.getItem('autoscl')
   console.log autoscl
   if rfocus isnt 'on' and autoscl is 'on'
    console.log "dfafsf"
    sclba = $("div##{message.comment_id}").offset().top
    sclba = sclba - 100
    if treeb is 'on'
      setTimeout ->
       $("html,body").animate({scrollTop:sclba})
      , 3000
    else if treeb is 'off'
      console.log "momoi"
      $("html,body").animate({scrollTop:sclba})

  return 0
 #画像読み込みタイムアウト
 price: () ->
 #エスケープ処理
 mescape: (mbody,mnum) ->
    if mbody.match(/>>\d{1,3}/)
      resmecom = mbody.match(/>>(\d{1,3})/)
      if resmecom[1] < mnum
       resmename = $("a.anker:contains(#{resmecom[1]})").attr "name"
       resmeid = resmename.substr(3)
       resmeclass = $("div##{resmeid}").attr "class"
       if resmeclass.match(/blue/)
         resme = 1
       else
         resme = 0
      mbb =  mbody.replace(/&/g, "&amp;")
                  .replace(/"/g, "&quot;")
                  .replace(/</g, "&lt;")
                  .replace(/>/g, "&gt;")
                  .replace(/\r\n/g, "<br />")
                  .replace(/(\n|\r)/g, "<br />")
                  .replace(/&gt;&gt;(\d{1,3})/g, (match,p1,offset,string)->
                    if p1 < mnum
                     com = $("a.anker:contains(#{p1})").attr "name"
                     comid = com.substr(3)
                     ret = "<a class='resanker' name='#{comid}'>#{match}</a>"
                    else
                     ret = "&gt;&gt;#{p1}"
                    return ret
                    )
    else
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
    return [mba3,mba2,resme]
 

 #返信数とツールチップ用関数 
 resinc: (incnum,mbody,mnum,mtime,resid,onlyforme) ->
  
  #rescount
  rescount = parseInt(incnum.text(),0)
  if(isNaN(rescount))
    rescount = 0
  hres = rescount + 1
  if(hres is 1)
    incnum.attr 'class','badge rescof'
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
  date = @datestore.date_push()
  if @group_id is @build
    @lstorage.myres[0] = date[0]["comment_id"]
  @count = 0
  console.log @count
  for i in date
    if @count > @lstorage.rescount
      newpost = 'on'
    else
      newpost = 'off'
    if @lstorage.myres.indexOf(i.resid) isnt -1
      @output.output(newpost,@count,i,@tree,@akares,@onlyf,1)
    else if @lstorage.myres.indexOf(i.comment_id) is -1
      @output.output(newpost,@count,i,@tree,@akares,@onlyf)
    else
      @output.output(newpost,@count,i,@tree,@akares,@onlyf,0,1)
    @count++
  @lstorage.rescount = @count
  @lstorage.push_storage(@group_id)

 bindEvents: (idy) =>
# 送信ボタンが押されたらサーバへメッセージを送信
  $('#send').on 'click', @sendMessage
  $('button.resend').on 'click',{test:idy}, @resendMessage

# サーバーからnew_messageを受け取ったらreceiveMessageを実行
  @channel.bind 'websocket_chat', @receiveMessage
  @dispatcher.bind 'websocket_chat', @receiveMessage
  @channel.bind 'leave',@leave
  @channel.bind 'in',@in
 
 leave: (m) =>
  num = $("span#visitor-num").text()
  num = num - 1
  $("span#visitor-num").text(num)
  
 in: (m) =>
  terget = $("div#visit-c")
  beforeclass = target.attr "class"
  target.attr class: "#{beforeclass} visitor-come"
  num = $("span#visitor-num").text()
  num = num + 1
  $("span#visitor-num").text(num)
  setTimeout ->
    target.attr class: "#{beforeclass}"
  ,3000

 sendMessage: (event) =>
# サーバ側にsend_messageのイベントを送信
# オブジェクトでデータを指定
  $("#send,.resend").attr disabled:"disabled"
  $("#send,.resend").text("wait")
  msg_body = $('#msgbody').val()
  group_id = $('#group_id').text()
  imgurl = $('#imgurl').attr("value")
  $('#imgurl').removeAttr("value")
  @channel.trigger 'websocket_chat', {  body: msg_body , group_id: group_id, imgurl: imgurl}
  $('#msgbody').val('')
  setTimeout ->
    $("#send,.resend").removeAttr("disabled")
    $("#send,.resend").text("送信")
  ,3000
 resendMessage: (event) ->
  #クリックした要素を参照
  $("#send,.resend").attr disabled:"disabled"
  $("#send,.resend").text("wait")
  resid = $(this).attr('id')
  msg_body = $("#msgbody#{resid}").val()
  group_id = $('#group_id').text()
  imgurl = $("#imgurl#{resid}").attr("value")
  $("#imgurl#{resid}").removeAttr("value")
  #ChatClassを参照  
  event.data.test.channel.trigger 'websocket_chat', {  body: msg_body , group_id: group_id , resid: resid , imgurl: imgurl}
  $("#msgbody#{resid}").val('')
  $("div#form#{resid}").toggle(250)
  setTimeout ->
    $("#send,.resend").removeAttr("disabled")
    $("#send,.resend").text("送信")
  , 3000

 receiveMessage: (message) =>
  #くらいあんとID 取得
  unless message.first_id?
    @datestore.date_add(message)
    @lstorage.rescount++
    date = @datestore.date_push()
    newpost = "on"
    if message.client_id is @client_id
      @lstorage.myres.push(message.comment_id)
      @lstorage.push_storage(@group_id)
      @output.output(newpost,@count,message,@tree,@akares,@onlyf,0,1)
    else if message.resid?  and @lstorage.myres.indexOf(message.resid) isnt -1
      @output.output(newpost,@count,message,@tree,@akares,@onlyf,1)
    else
      @output.output(newpost,@count,message,@tree,@akares,@onlyf)
    
    @count++
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
  #スマホスリープ明け再接続処理
  last_update = new Date()
  TIMEOUT = 30000
  INTERVAL = 30000

  setInterval ->
    now = new Date()
    if now.getTime() - last_update.getTime() > INTERVAL + TIMEOUT
      location.reload()

    last_update = now
  , INTERVAL
  
  #入室時はオートスクロールオフ
  sessionStorage.setItem('autoscl','off')


  #ボタンの状態判断用
  gcid = $('#group_id').text()
  bid = ['autopic']

  if($.cookie(bid) isnt 'off' )
    $("##{bid}").attr 'class','btn btn-default navbar-btn navbtn active'
  else
    $("##{bid}").attr 'class','btn btn-default navbar-btn navbtn'

  $.cookie("nowload",gcid)

  #ヘッダーボタン処理
  $('.navbar-btn').click ->
    $(this).button('toggle')
    cookid = $(this).attr('id')
    if sessionStorage.getItem('autoscl') isnt 'on' or $.cookie(cookid) isnt 'on'
     sessionStorage.setItem('autoscl','on')
     $.cookie(cookid,'on')
    else
     sessionStorage.setItem('autoscl','off')
     $.cookie(cookid,'off')
  
 
  topicEvents = new ChatClass($('#chat').data('uri'), true)
  
  #タブ処理
  $('.tnav').on 'click', ->
    id = $(this).attr("id")
    topicEvents.reset(id)


  #res anker animetion 
  $('#chat').on 'click','a.resanker', ->
    resid = $(this).attr('name')
    sclbaa = $("div##{resid}").offset().top
    sclbaa = sclbaa - 100
    $("html,body").animate({scrollTop:sclbaa})

  #colorbox読み込み
  $('#chat').on 'click','a.colgm', ->
    iden = $(this).attr('name')
    idena = $(this).attr('id')
    $("a.#{iden}").colorbox(
     rel:"#{iden}"
     maxWidth:"100%"
     maxHeight:"100%"
    )
  #thumbnail colorbox読み込み
  $('#chat').on 'click','img.bigthum', ->
    $(this).colorbox(
      href: $(this).attr 'data-original'
      maxWidth:"100%"
      maxHeight:"100%"
    )
  
  #返信用バッチのポップオーバー
  $(document).popover(
    html: true,
    selector:'.badge',
    content: ->
      $(this).attr('data-content')
  )
  
  #画像アップロード処理
  
  $("body").on 'click', 'input.image', ->
   $file = $(this)
   $input = $(this).prev()
   $file.on 'change', ->
     [file] = $file.get(0).files
     
     if typeof file isnt"undefined"
      fr = new FileReader
      $("#send,.resend").attr disabled:"disabled"
      $("#send,.resend").text("wait")
      fr.readAsBinaryString(file)
      fr.onload = (event) =>
       pic = window.btoa(event.target.result)
       $.ajax({
        url: "https://api.imgur.com/3/image",
        headers: {
          'Authorization': 'Client-ID 2f91e49e1313411'
        },
        type:"POST",
        data: {
          type:"base64"
          image:pic
          }
        }).done (page)->
          $("#send,.resend").removeAttr("disabled")
          $("#send,.resend").text("送信")
          $input.attr value:page.data.link
        .fail ()->
          $("#send,.resend").removeAttr("disabled")
          $("#send,.resend").text("送信")
          alert "画像のアップロードに失敗しました"


  #NG処理        
  $("#chat").on 'click', '.nguser', ->
    console.log "ad"
    ngid = $(this).attr("data-cid")
    console.log ngid
    if($(".m#{ngid}").attr("style") is "display:none;")
      $(".m#{ngid}").attr style: ""
      sessionStorage.removeItem(ngid)
    else
      $(".m#{ngid}").attr style: "display:none;"
      sessionStorage.setItem(ngid,'on')

  $("span#sclup").on 'click', ->
      $('body,html').animate({scrollTop: 0}, 500)
  $("span#scldown").on 'click', ->
      $('body,html').animate({scrollTop:$(document).height()},500)



  ################フッター処理####################################
  
  #footerタッチ処理
  
  $("li.fbtn")
    .on 'touchstart', ->
      $(this).attr class:"fbtn footer-touch"
    .on 'touchend', ->
      $(this).attr class:"fbtn"

  #TOPボタン処理

  $("li#goTop").on 'click', ->
    $('body,html').animate({scrollTop: 0}, 500)
  #オートスクロールボタン処理
  $('div#autosclimg,.autoscl').click ->
    if sessionStorage.getItem('autoscl') is "on"
      sessionStorage.setItem('autoscl','off')
      $('div#autosclimg').attr class:"onautotag"
    else
      sessionStorage.setItem('autoscl','on')
      $("div#autosclimg").attr class:"autotag"



  #bottomに表示領域の一番下を指定するように
  #投稿form処理
  formp = $("div#chat")
  moi = $.cookie("restextfocus")
    
  $("li#hform").on 'click', ->
    $.cookie("restextfocus","on")
    $("div.form-m").animate
      bottom:'0'
    ,200, ->
      formp.attr class: "body-pad"
      $("div.footer-cont").attr style: "display:none;"
      $("#send").click ->
        $.cookie("restextfocus","off")
        $("div.footer-cont").attr style: ""
        formp.attr class: ""
        $("div.form-m").animate
          bottom:'-300'
        ,200
  
  $("span.closebutton").on 'click', ->
    $.cookie("restextfocus","off")
    $("div.footer-cont").attr style: ""
    formp.attr class:""
    $("div.form-m,div.reform-m").animate
      bottom:'-300'
      ,200
  
  #返信フォーム
  $("#chat").on 'click',"a.res", ->
    $.cookie("restextfocus","on")
    comid = $(this).attr "id"
    $("input.resimg").attr id: "imgurl#{comid}"
    $("textarea.restext").attr id: "msgbody#{comid}"
    $("button.resend").attr id: "#{comid}"
    $("div.reform-m").animate
      bottom:'0'
    ,200, ->
      formp.attr class: "body-pad"
      $("div.footer-cont").attr style: "display:none;"
      $(".resend").click ->
        $.cookie("restextfocus","off")
        $("div.footer-cont").attr style: ""
        formp.attr class: ""
        $("div.reform-m").animate
          bottom:'-300'
        ,200
  
  #オートスクロールオン
  $("#chat").on 'inview','div.contarea:last', (event,isInView)->
    if isInView
      sessionStorage.setItem('autoscl','on')
      $("div#autosclimg").attr class:"onautotag"
    else
      sessionStorage.setItem('autoscl','off')
      $('div#autosclimg').attr class:"autotag"

