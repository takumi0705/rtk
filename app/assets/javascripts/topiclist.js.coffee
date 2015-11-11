 class Callist
 
  constructor: (@list) ->
  
  #新着順
  sort_by: (sort)->
    compSort_By.call @,sort
 
  escape_html: (target) ->
    escape_by.call @,target

  compSort_By = (sortby) ->
    @list.sort (a,b) ->
      b[sortby] - a[sortby]
    return @

  escape_by = (target) ->
    $.each @list, (index,elem)->
      elem[target] =  elem[target].replace(/&/g, "&amp;")
                                  .replace(/"/g, "&quot;")
                                  .replace(/</g, "&lt;")
                                  .replace(/>/g, "&gt;")
    return @
  pubfunc:() ->
    @list

 class OutputList
  
  output_list:(raw) ->
    output_by_list.call @,raw

  output_by_list = (list) ->
    $("div.list-group").empty()
    time = new Date()
    $.each list, (index,value) ->
      time.setTime(value[4] * 1000)
      date = formatDate.call @,time
      top = "<a class='list-group-item' href='/topic/#{value[6]}' >
                  <div class='row10 row'>
                    <div class='rowr imgdiv col-xs-2 col-md-2 col-sm-2'>"
      if value[5] isnt null or value[5] is ""
        url = value[5].replace(/\.(\w*)$/g,"m.$1")
        img =        "<img class='list_thumb' src='#{url}'>"
        top = top + img
      bottom ="     </div>
                    <div class='rowr col-xs-10 col-md-10 col-sm-10'>
                      <h4 class='overf list-group-item-heading'>#{value[0]}</h4>
                      <p class='list-group-item-text'><span class='user'>&nbsp;</span><span>:&nbsp;<strong>#{value[2]}</strong></span></p>
                      <p class='list-group-item-text'><span class='comeimg'>&nbsp;</span><span>:&nbsp;<strong>#{value[1]}</strong></span></p>
                      <p class='list-group-item-text'><span class='text-primary'>open:</span><small>#{date}</small>
                      <span class='text-primary'> last:</span><small>#{value[3]}<small></p>
                    </div>
                  </div>
            </a>"
      
      $("div.list-group").append "#{top}#{bottom}"
    
  formatDate = (date, format = 'YYYY/MM/DD hh:mm:ss') ->
   format = format.replace /YYYY/g, date.getFullYear()
   format = format.replace /MM/g, ('0' + (date.getMonth() + 1)).slice(-2)
   format = format.replace /DD/g, ('0' + date.getDate()).slice(-2)
   format = format.replace /hh/g, ('0' + date.getHours()).slice(-2)
   format = format.replace /mm/g, ('0' + date.getMinutes()).slice(-2)
   format = format.replace /ss/g, ('0' + date.getSeconds()).slice(-2)
   if format.match /S/g
      milliSeconds = ('00' + date.getMilliseconds()).slice(-3)
      length = format.match(/S/g).length
      format.replace /S/, milliSeconds.substring(i, i + 1) for i in [0...length]
   return format
 
 class UserModel

  constructor:(sortnum) ->
    @listm = new Callist(gon.list)
    @view = new OutputList()
    @cal(sortnum)

  cal: (target) =>
    @listm.sort_by(target).escape_html(0)
    @view.output_list(@listm.pubfunc())
  
 $ ->
  open = new UserModel(2)
  $("#pop").on 'click', ->
    open.cal(2)
    $(".tnav").attr('class','tnav')
    $(this).attr('class','tnav active')
  $("#new").on 'click', ->
    open.cal(4)
    $(".tnav").attr('class','tnav')
    $(this).attr('class','tnav active')
  $("#come").on 'click', ->
    open.cal(1)
    $(".tnav").attr('class','tnav')
    $(this).attr('class','tnav active')

