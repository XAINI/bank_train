class PostModal
#岗位模态框
  constructor: (@$elm)->
    @bind_events()
    @global = false

  # 提交表单成功 相关操作
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
          # 列表页 滚动条滑至底端(创建)
          window.modal_dialog.set_scroll_bottom(".page-posts-index")
          jQuery(msg.body)
            .hide()
            .fadeIn(500)
            .appendTo @$elm.find(".post-list tbody")
        else
          # 列表页 条目颜色由深至浅(修改条目)
          tag = $("div a[data-post-id = '#{post_id}']").parents(".post")
          tag.replaceWith( msg.body )
          bc = jQuery("tr:first").css("backgroundColor")
          $("div a[data-post-id = '#{post_id}']").parents(".post").css("backgroundColor","#D9DD77")
          $("div a[data-post-id = '#{post_id}']").parents(".post").animate({backgroundColor: bc})
      window.modal_dialog.hide()
      @global = false

  # 表单提交失败 相关操作(为空验证显示提示信息)
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

  # 将数组转成树
  get_children_r: (cate, categories)->
    nodes = @get_children(cate, categories)
    cate.nodes = nodes if cate != null
    for node in nodes
      node.text = node.name
      @get_children_r(node, categories)
    nodes
  get_children: (parent, categories)->
    children = []
    parent_id = if parent == null then "" else parent.id
    for cate in categories
      if cate.parent_id == parent_id
        children.push cate
    children

  #业务种类树
  set_bsns_ctgr_tree: (tree_to_bsns_ctgr)->
    tree = jQuery('.modal-content .modal-body .tree').treeview
      data: tree_to_bsns_ctgr
      showIcon: false,
      selectable: true,
      highlightSelected: false,
      showCheckbox: true,
      onNodeChecked: (event, node)->
        if node.nodes
          ids = jQuery.map node.nodes, (n)->
            n.nodeId
          tree.treeview('checkNode', [ ids, { silent: false } ])
      ,
      onNodeUnchecked: (event, node)->
        parent = tree.treeview('getParent', node)
        if parent.context != document && parent.state.checked
          tree.treeview 'checkNode', node.nodeId

        if node.nodes
          ids = jQuery.map node.nodes, (n)->
            n.nodeId
        tree.treeview('uncheckNode', [ ids, { silent: false } ])

  bind_events: ->
    that = this
    # 创建岗位
    # 点击创建按钮设置模态框（弹出模态框）
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
    # 点击提交表单(创建)
    window.modal_dialog.get_modal_dialog().on "submit",".modal-body .page-posts-form-new .simple_form",(event) ->
      event.preventDefault()
      post_form_data = $( this ).serializeArray()
      # 表单中如果初始化了业务种类树并选择了业务种类，则将选中的业务种类的 id 追加入
      # post_form_data 中
      tree = that.tree_to_bsns_ctgr
      if tree isnt undefined
        tree_ids = $.map($('.modal-content .modal-body .tree').treeview('getChecked', 0),(tree) -> return tree.id)
        for bsns_id in tree_ids
          bsns_tree_ids = { 'name' : 'post[business_category_ids][]', 'value' : bsns_id }
          post_form_data.push( bsns_tree_ids )
      $.ajax
        method: "POST",
        url: "/posts",
        data: post_form_data
      .success ( msg ) =>
        that.set_success_im(msg)
      .error (msg) =>
        that.set_failure_im(msg)
    # 点击头 关闭模态框按钮 通过data 设置@global = false 
    window.modal_dialog.get_modal_dialog().on "click", ".modal-content .modal-header .close", =>
      @global = jQuery(".modal-content .modal-header .close").data("global")
    # 点击脚 关闭模态框按钮 通过data 设置@global = false 
    window.modal_dialog.get_modal_dialog().on "click", ".modal-content .modal-footer .close-modal", =>
      @global = jQuery(".modal-content .modal-footer .close-modal").data("global")
    # 点击 业务种类按钮 设置业务种类树（显示树 隐藏表单）
    window.modal_dialog.get_modal_dialog().on "click", ".modal-content .modal-body .post_business_categories .bsns_btn", =>
      if @global is false
        ctgr_selected_data = jQuery(".modal-content .modal-body .tree").data("ctgr-selected")
        jQuery.ajax
          url: "/business_categories.json"
          method: "get"
          dataType: "json"
        .success (msg) ->
          that.tree_to_bsns_ctgr = that.get_children_r( null, msg )
          tree = that.set_bsns_ctgr_tree(that.tree_to_bsns_ctgr)
          # 业务种类的数量 cate_count
          cate_count = msg.length
          # 需要选中的分类的 数据库条目 id 数组 select_cate_ids
          select_cate_ids = jQuery.map ctgr_selected_data, (item)->
            item.id
          # treeview node 数组 {id: xxx nodeId: xxx} treeview_nodes
          treeview_nodes = jQuery.map [0..cate_count-1], (index)->
            tree.treeview 'getNode', index
          # treeview_nodes 数组和select_cate_ids 数组比对 
          # 找到对应的条目 将nodeId 追加入 select_nodeIds 数组中
          select_nodeIds = []
          for node in treeview_nodes
            if -1 != jQuery.inArray node.id, select_cate_ids
              select_nodeIds.push node.nodeId

          jQuery(".modal-content .modal-body .simple_form").addClass("hide")
          jQuery(".modal-content .modal-body .tree").removeClass("hide")
          jQuery(".modal-content .modal-body .tree-button").removeClass("hide")
          jQuery(".modal-content .modal-body .tree").appendTo(that.set_bsns_ctgr_tree(that.tree_to_bsns_ctgr))
          # 回显数据库中已有业务种类(在树中显示选中状态)
          tree.treeview('checkNode', [ select_nodeIds, { silent: false } ])
        .error (msg) =>
          console.log(msg)
      else
        jQuery(".modal-content .modal-body .simple_form").addClass("hide")
        jQuery(".modal-content .modal-body .tree").removeClass("hide")
        jQuery(".modal-content .modal-body .tree-button").removeClass("hide")
    # 点击树中的确定按钮，隐藏树 显示表单
    window.modal_dialog.get_modal_dialog().on "click", ".modal-content .modal-body .tree-button", =>
      jQuery(".modal-content .modal-body .tree").addClass("hide")
      jQuery(".modal-content .modal-body .simple_form").removeClass("hide")
      jQuery(".modal-content .modal-body .tree-button").addClass("hide")
      @global = true

    # 岗位信息修改
    # 点击修改按钮 设置模态框(显示模态框)
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
    # 点击提交表单(修改)
    window.modal_dialog.get_modal_dialog().on "submit",".modal-body .page-posts-form-edit .simple_form", ->
      post_id = $(this).closest(".page-posts-form-edit").attr("data-post-id")
      event.preventDefault()
      post_form_data = $( this ).serializeArray()
      # 表单中如果初始化了业务种类树并选择了业务种类，则将选中的业务种类的 id 追加入
      # post_form_data 中
      tree = that.tree_to_bsns_ctgr
      if tree isnt undefined
        tree_ids = $.map($('.modal-content .modal-body .tree').treeview('getChecked', 0),(tree) -> return tree.id)
        for bsns_id in tree_ids
          bsns_tree_ids = { 'name' : 'post[business_category_ids][]', 'value' : bsns_id }
          post_form_data.push( bsns_tree_ids )
      $.ajax
        method: "PATCH",
        url: "/posts/"+post_id+"",
        data: post_form_data
      .success ( msg ) =>
        that.set_success_im(msg,post_id)
      .error (msg) =>
        that.set_failure_im(msg,post_id)

class LevelModal
# 级别模态框
  constructor: (@$elm)->
    @bind_events()
  # 表单提交成功 相关操作
  set_success_im: (msg,level_id)->
    if msg.status is 200
      window.modal_dialog.set_remove_css(".level_number")
      window.modal_dialog.set_remove_css(".level_name")
      window.modal_dialog.get_modal_dialog().one "hidden.bs.modal", =>
        if level_id is undefined
          # 滚动条滚至底端(创建)
          window.modal_dialog.set_scroll_bottom(".page-levels-index")
          jQuery(msg.body)
            .hide()
            .fadeIn(500)
            .appendTo @$elm.find(".level-list tbody")
        else
          # 条目颜色由深到浅 (修改)
          tag = $("div a[data-level-id= '#{level_id}']").parents(".level")
          tag.replaceWith(msg.body)
          bc = jQuery("tr:first").css("backgroundColor")
          $("div a[data-level-id= '#{level_id}']").parents(".level").css("backgroundColor","#D9DD77")
          $("div a[data-level-id= '#{level_id}']").parents(".level").animate({backgroundColor: bc})
      window.modal_dialog.hide()

  # 表单提交失败 相关操作(为空验证显示提示信息)
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

    # 创建级别
    #点击创建按钮 设置模态框(显示模态框)
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
    # 提交表单(创建)
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
    # 点击 修改按钮 设置模态框(显示模态框)
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
    # 提交表单(修改)
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
