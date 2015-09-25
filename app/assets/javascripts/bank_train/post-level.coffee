class PostModal
#岗位模态框
  constructor: (@$elm)->
    @bind_events()

  set_success_im: (msg,post_id)->
    if msg.status is 200
      window.modal_dialog.set_remove_css(".post_number")
      window.modal_dialog.set_remove_css(".post_number")
    # 如果把这个注册事件代码移动到 bind_events 方法内
    # 会导致 set_scroll_bottom 方法内的代码没有产生效果
    # 原因未知
    # by fushang318
      window.modal_dialog.get_modal_dialog().one 'hidden.bs.modal', =>
        if post_id is undefined
          window.modal_dialog.set_scroll_bottom(".page-posts-index")
          jQuery(msg.body)
            .hide()
            .fadeIn(500)
            .appendTo @$elm.find(".post-list tbody")
        else
          tag = $("div a[data-post-id = '#{post_id}']").parents(".post")
          tag.replaceWith( msg.body )
          bc = jQuery("tr:first").css("backgroundColor")
          $("div a[data-post-id = '#{post_id}']").parents(".post").css("backgroundColor","#D9DD77")
          $("div a[data-post-id = '#{post_id}']").parents(".post").animate({backgroundColor: bc})
      window.modal_dialog.hide()

  set_failure_im: (msg)->
    msg_number = msg.responseJSON.number
    msg_name = msg.responseJSON.name
    if msg.status is 413
      if msg_number isnt undefined
        window.modal_dialog.set_add_css(".post_number",msg_number)
      else
         window.modal_dialog.set_remove_css(".post_number")

      if msg_name isnt undefined
        window.modal_dialog.set_add_css(".post_name",msg_name)
      else
        window.modal_dialog.set_remove_css(".post_name")

      if (msg_number isnt undefined) and (msg_name isnt undefined)
        jQuery(".modal-body .simple_form input[name='post[number]']").focus()
      else if(msg_number isnt undefined)
        jQuery(".modal-body .simple_form input[name='post[number]']").focus()
      else
        jQuery(".modal-body .simple_form input[name='post[name]']").focus()

  get_children_r: (cate, categories)->
    nodes = @get_children(cate, categories)
    cate.nodes = nodes if cate != null
    for text in nodes
      @get_children_r(text, categories)
    nodes

  get_children: (parent, categories)->
    children = []
    parent_id = if parent == null then "" else parent.id
    for cate in categories
      if cate.parent_id == parent_id
        children.push cate
    children

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

    window.modal_dialog.get_modal_dialog().on "submit",".modal-body .page-posts-form-new .simple_form",(event) ->
      event.preventDefault()
      $.ajax
        method: "POST",
        url: "/posts",
        data: $( this ).serializeArray()
      .success ( msg ) =>
        that.set_success_im(msg)
      .error (msg) =>
        that.set_failure_im(msg)

    window.modal_dialog.get_modal_dialog().on "click", ".modal-content .modal-body .post_business_categories .bsns_btn", =>
      jQuery.ajax
        url: "/business_categories.json"
        method: "get"
        dataType: "json"
      .success (msg) ->
        # 1 把服务器返回的 json(array 格式) 转换成 json( tree 结构)
        # 2 替换模态框的 body 内容为 <div class="tree"/>
        # 3 通过调用 jQuery('.modal-content .modal-body .tree').treeview(详细参数)
        #   把 <div class="tree"/> 替换成要显示的树状内容
        tree_to_bsns_ctgr = that.get_children_r( null, msg )
        jQuery(".modal-content .modal-body .simple_form").addClass("hide")
        jQuery(".modal-content .modal-body .tree").removeClass("hide")
        jQuery(".modal-content .modal-body .tree-button").removeClass("hide")
        jQuery(".modal-content .modal-body .tree").appendTo(window.modal_dialog.set_bsns_ctgr_tree(tree_to_bsns_ctgr))
      .error (msg) =>
        console.log(msg)

    window.modal_dialog.get_modal_dialog().on "click", ".modal-content .modal-body .tree-button", =>
      jQuery(".modal-content .modal-body .tree").addClass("hide")
      jQuery(".modal-content .modal-body .simple_form").removeClass("hide")
      jQuery(".modal-content .modal-body .tree-button").addClass("hide")

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

    window.modal_dialog.get_modal_dialog().on "submit",".modal-body .page-posts-form-edit .simple_form", ->
      post_id = $(this).closest(".page-posts-form-edit").attr("data-post-id")
      event.preventDefault();
      $.ajax
        method: "PATCH",
        url: "/posts/"+post_id+"",
        data: $( this ).serializeArray()
      .success ( msg ) =>
        that.set_success_im(msg,post_id)
      .error (msg) =>
        that.set_failure_im(msg,post_id)

class LevelModal
# 级别模态框
  constructor: (@$elm)->
    @bind_events()

  set_success_im: (msg,level_id)->
    if msg.status is 200
      window.modal_dialog.set_remove_css(".level_number")
      window.modal_dialog.set_remove_css(".level_name")
      window.modal_dialog.get_modal_dialog().one "hidden.bs.modal", =>
        if level_id is undefined
          window.modal_dialog.set_scroll_bottom(".page-levels-index")
          jQuery(msg.body)
            .hide()
            .fadeIn(500)
            .appendTo @$elm.find(".level-list tbody")
        else
          tag = $("div a[data-level-id= '#{level_id}']").parents(".level")
          tag.replaceWith(msg.body)
          bc = jQuery("tr:first").css("backgroundColor")
          $("div a[data-level-id= '#{level_id}']").parents(".level").css("backgroundColor","#D9DD77")
          $("div a[data-level-id= '#{level_id}']").parents(".level").animate({backgroundColor: bc})
      window.modal_dialog.hide()

  set_failure_im: (msg,level_id)->
    msg_level_number = msg.responseJSON.number
    msg_level_name = msg.responseJSON.name
    if msg.status is 413
      if msg_level_number isnt undefined
        window.modal_dialog.set_add_css(".level_number",msg_level_number)
      else
        window.modal_dialog.set_remove_css(".level_number")

      if msg_level_name isnt undefined
        window.modal_dialog.set_add_css(".level_name",msg_level_name)
      else
        window.modal_dialog.set_remove_css(".level_name")

      if (msg_level_number isnt undefined) and (msg_level_name isnt undefined)
        jQuery(".modal-body .simple_form input[name='level[number]']").focus()
      else if(msg_level_number isnt undefined)
        jQuery(".modal-body .simple_form input[name='level[number]']").focus()
      else
        jQuery(".modal-body .simple_form input[name='level[name]']").focus()

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

    window.modal_dialog.get_modal_dialog().on "submit",".modal-body .page-levels-new .simple_form", (event) ->
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

    window.modal_dialog.get_modal_dialog().on "submit",".modal-body .page-levels-edit .simple_form", (event) ->
      level_id = $( this ).closest(".page-levels-edit").attr("data-level-id")
      event.preventDefault()
      $.ajax
        method: "PATCH",
        url: "/levels/"+level_id+"",
        data: $( this ).serializeArray()
      .success ( msg ) =>
        that.set_success_im(msg,level_id)
      .error (msg) =>
        that.set_failure_im(msg,level_id)

jQuery(document).on 'ready page:load', ->
  if $(".page-posts-index").length > 0
    new PostModal $(".page-posts-index")

  if $(".page-levels-index").length > 0
    new LevelModal $(".page-levels-index")
