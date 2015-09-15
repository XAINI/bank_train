class PostModal
#岗位模态框
  constructor: (@$elm)->
    @bind_events()

  set_post_css: (css,msg_val)->
    @set_post_remove_css(css)
    $(css).addClass("has-error")
    $(css).append("<span class='help-block'>#{msg_val}</span>")

  set_post_remove_css:(class_css)->
    $(class_css).removeClass("has-error")
    $(class_css+" span").remove();

  set_success_im: (msg)->
    if msg.status is 200
      @set_post_remove_css(".post_number")
      @set_post_remove_css(".post_name")
      window.modal_dialog.hide()
      location.reload();

  set_failure_im: (msg)->
    msg_number = msg.responseJSON.number
    msg_name = msg.responseJSON.name
    if msg.status is 413
      if msg_number isnt undefined
        @set_post_css(".post_number",msg_number)
      else
         @set_post_remove_css(".post_number")

      if msg_name isnt undefined
        @set_post_css(".post_name",msg_name)
      else
        @set_post_remove_css(".post_name")

  bind_events: ->
    that = this
    @$elm.on "click",".post-crt", ->
      $.ajax
        url: "/posts/new",
        method: "get",
        dataType: "json"
      .success (msg) ->
        window.modal_dialog.set_title( msg.title )
        window.modal_dialog.set_body( msg.body )
      .error (msg) ->
        console.log(msg)

    @$elm.on "submit",".page-posts-form-new .simple_form",(event) ->
      event.preventDefault()
      $.ajax
        method: "POST",
        url: "/posts",
        data: $( this ).serializeArray()
      .success ( msg ) =>
        that.set_success_im(msg)
      .error (msg) =>
        that.set_failure_im(msg)

    # 岗位信息修改
    @$elm.on "click",".post-list .post .update-post", ->
      post_id = $(this).closest(".update-post").attr("data-post-id")
      $.ajax
        url: "/posts/" + post_id + "/edit",
        method: "get",
        dataType: "json"
      .success (msg) ->
        window.modal_dialog.set_title( msg.title )
        window.modal_dialog.set_body( msg.body )
      .error (msg) ->
        console.log(msg)

    @$elm.on "submit",".page-posts-form-edit .simple_form", ->
      post_id = $(this).closest(".page-posts-form-edit").attr("data-post-id")
      event.preventDefault();
      $.ajax
        method: "PATCH",
        url: "/posts/"+post_id+"",
        data: $( this ).serializeArray()
      .success ( msg ) =>
        that.set_success_im(msg)
      .error (msg) =>
        that.set_failure_im(msg)

class LevelModal
# 级别模态框
  constructor: (@$elm)->
    @bind_events()

  set_level_css: (css,msg_val)->
    @set_level_remove_css(css)
    $(css).addClass("has-error")
    $(css).append("<span class='help-block'>#{msg_val}</span>")

  set_level_remove_css: (class_level)->
    $(class_level).removeClass("has-error")
    $(class_level+" span").remove();
  set_success_im: (msg)->
    if msg.status is 200
      @set_level_remove_css(".level_number")
      @set_level_remove_css(".level_name")
      window.modal_dialog.hide()
      location.reload();

  set_failure_im: (msg)->
    msg_level_number = msg.responseJSON.number
    msg_level_name = msg.responseJSON.name
    if msg.status is 413
      if msg_level_number isnt undefined
        @set_level_css(".level_number",msg_level_number)
      else
        @set_level_remove_css(".level_number")

      if msg_level_name isnt undefined
        @set_level_css(".level_name",msg_level_name)
      else
        @set_level_remove_css(".level_name")

  bind_events: ->
    that = this

    @$elm.on "click",".level-crt", ->
      $.ajax
        url: "/levels/new",
        method: "get",
        dataType: "json"
      .success (msg) ->
        window.modal_dialog.set_title( msg.title )
        window.modal_dialog.set_body( msg.body )
      .error (msg) ->
        console.log(msg)

    @$elm.on "submit",".page-levels-new .simple_form", (event) ->
      event.preventDefault()
      $.ajax
        method: "POST",
        url: "/levels",
        data: $( this ).serializeArray()
      .success ( msg ) =>
        that.set_success_im(msg)
      .error (msg) =>
        that.set_failure_im(msg)

    # 级别信息修改
    @$elm.on "click", ".level-list .level .update-level", ->
      level_id = $(this).closest(".update-level").attr("data-level-id")
      $.ajax
        url: "/levels/" + level_id + "/edit",
        method: "get",
        dataType: "json"
      .success (msg) ->
        window.modal_dialog.set_title( msg.title )
        window.modal_dialog.set_body( msg.body )
      .error (msg) ->
        console.log(msg)

    @$elm.on "submit",".page-levels-edit .simple_form", (event) ->
      level_id = $( this ).closest(".page-levels-edit").attr("data-level-id")
      event.preventDefault()
      $.ajax
        method: "PATCH",
        url: "/levels/"+level_id+"",
        data: $( this ).serializeArray()
      .success ( msg ) =>
        that.set_success_im(msg)
      .error (msg) =>
        that.set_failure_im(msg)

jQuery(document).on 'ready page:load', ->
  if $(".page-posts-index").length > 0
    new PostModal $(".page-posts-index")

  if $(".page-levels-index").length > 0
    new LevelModal $(".page-levels-index")
