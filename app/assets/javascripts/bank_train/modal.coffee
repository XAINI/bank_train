class ModalDialog
  constructor: (@$modal_dialog_ele)->
    @$title_ele = @$modal_dialog_ele.find(".modal-title")
    @$body_ele  = @$modal_dialog_ele.find(".modal-body")

  set_title: (title)->
    @$title_ele.html(title)

  set_body: (body)->
    @$body_ele.html(body)

  set_remove_css:(class_css)->
    $(class_css).removeClass("has-error")
    $(class_css+" span").remove();

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

jQuery(document).on 'ready page:load', ->
  if $("#modal-dialog").length > 0
    window.modal_dialog = new ModalDialog($("#modal-dialog"))
