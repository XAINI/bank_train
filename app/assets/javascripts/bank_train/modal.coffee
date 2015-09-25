class ModalDialog
  constructor: (@$modal_dialog_ele)->
    @$title_ele = @$modal_dialog_ele.find(".modal-title")
    @$body_ele  = @$modal_dialog_ele.find(".modal-body")

  set_title: (title)->
    @$title_ele.html(title)

  set_body: (body)->
    @$body_ele.html(body)

  #移除样式 和提示信息
  set_remove_css:(class_css)->
    $(class_css).removeClass("has-error")
    $(class_css+" span").remove();

  #添加样式 和提示信息
  set_add_css: (css,msg_val)->
    @set_remove_css(css)
    $(css).addClass("has-error")
    $(css).append("<span class='help-block'>#{msg_val}</span>")

  hide: ->
    @$modal_dialog_ele.modal('hide')

  get_modal_dialog: ->
    @$modal_dialog_ele

  set_scroll_bottom: (class_by_page)->
    $(document).scrollTop($(class_by_page).height())


  #业务种类
  set_bsns_ctgr_tree: (tree_to_bsns_ctgr)->
    tree = jQuery('.modal-content .modal-body .tree').treeview
      data: tree_to_bsns_ctgr
      showIcon: false,
      selectable: false,
      highlightSelected: false,
      showCheckbox: true,
      onNodeChecked: (event, node)->
        console.log node
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

jQuery(document).on 'ready page:load', ->
  if $("#modal-dialog").length > 0
    window.modal_dialog = new ModalDialog($("#modal-dialog"))

