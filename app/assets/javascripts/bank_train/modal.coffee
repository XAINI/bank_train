class ModalDialog
  constructor: (@$modal_dialog_ele)->
    @$title_ele = @$modal_dialog_ele.find(".modal-title")
    @$body_ele  = @$modal_dialog_ele.find(".modal-body")

  set_title: (title)->
    @$title_ele.html(title)

  set_body: (body)->
    @$body_ele.html(body)

  hide: ->
    @$modal_dialog_ele.modal('hide')

jQuery(document).on 'ready page:load', ->
  if $("#modal-dialog").length > 0
    window.modal_dialog = new ModalDialog($("#modal-dialog"))
