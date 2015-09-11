jQuery(document).on 'ready page:load', ->
  # 新增岗位
  jQuery(".page-posts-form-new").on "submit",".simple_form",(event) ->
    event.preventDefault();
    $.ajax
      method: "POST",
      url: "/posts",
      data: $( this ).serializeArray()
    .success ( msg ) ->
      if msg.status is 200
        $(".post_number").removeClass("has-error")
        $(".post_number span").remove();
        $(".post_name").removeClass("has-error")
        $(".post_name span").remove();
        $('#myModal').modal('hide');
        location.reload();
    .error (msg) ->
      msg_number = msg.responseJSON.number
      msg_name = msg.responseJSON.name
      if msg.status is 413
        if msg_number isnt undefined 
          $(".post_number").removeClass("has-error")
          $(".post_number span").remove();
          $(".post_number").addClass("has-error")
          $(".post_number").append("<span class='help-block'>"+msg_number+"</span>")
        else
           $(".post_number").removeClass("has-error")
           $(".post_number span").remove();

        if msg_name isnt undefined  
          $(".post_name").removeClass("has-error")
          $(".post_name span").remove();
          $(".post_name").addClass("has-error")
          $(".post_name").append("<span class='help-block'>"+msg_name+"</span>")
        else
          $(".post_name").removeClass("has-error")
          $(".post_name span").remove();
        
  # 岗位信息修改 
  jQuery(document).on "click",".btn-group-sm .update-post", ->
    post_id = $(this).closest(".update-post").attr("data-post-id")
    $.ajax 
      url: "/posts/" + post_id + "/edit",
      method: "get",
      dataType: "html"
    .success (msg) ->
      $( "#post-edit" ).html( msg );
    .error (msg) ->
      console.log(msg)

  jQuery(document).on "submit",".page-posts-form-edit .simple_form", (event) ->
    values = $( this ).serializeArray()
    event.preventDefault();
    $.ajax 
      method: "PATCH",
      url: "/posts/"+values[3].value+"",
      data: $( this ).serializeArray()
    .success ( msg ) ->
      if msg.status is 200 
        $(".post_number").removeClass("has-error")
        $(".post_number span").remove();
        $(".post_name").removeClass("has-error")
        $(".post_name span").remove();
        $('#myEditModal').modal('hide');
        location.reload();
    .error (msg) ->
      msg_number = msg.responseJSON.number
      msg_name = msg.responseJSON.name
      if msg.status is 413 
        if msg_number isnt undefined 
          $(".post_number").removeClass("has-error")
          $(".post_number span").remove();
          $(".post_number").addClass("has-error")
          $(".post_number").append("<span class='help-block'>"+msg_number+"</span>")
        else 
           $(".post_number").removeClass("has-error")
           $(".post_number span").remove();
         
        if msg_name isnt undefined
          $(".post_name").removeClass("has-error")
          $(".post_name span").remove();
          $(".post_name").addClass("has-error")
          $(".post_name").append("<span class='help-block'>"+msg_name+"</span>")
        else 
          $(".post_name").removeClass("has-error")
          $(".post_name span").remove();


# 新增级别
  jQuery(".page-levels-new").on "submit",".simple_form", (event) ->
    event.preventDefault();
    $.ajax 
      method: "POST",
      url: "/levels",
      data: $( this ).serializeArray()
    .success ( msg ) ->
      if msg.status is 200 
        $(".level_number").removeClass("has-error")
        $(".level_number span").remove();
        $(".level_name").removeClass("has-error")
        $(".level_name span").remove();
        $('#myModal').modal('hide');
        location.reload();
    .error (msg) ->
      msg_level_number = msg.responseJSON.number
      msg_level_name = msg.responseJSON.name
      if msg.status is 413 
        if msg_level_number isnt undefined
          $(".level_number").removeClass("has-error")
          $(".level_number span").remove();
          $(".level_number").addClass("has-error")
          $(".level_number").append("<span class='help-block'>"+msg_level_number+"</span>")
        else
           $(".level_number").removeClass("has-error")
           $(".level_number span").remove();
        
        if msg_level_name isnt undefined 
          $(".level_name").removeClass("has-error")
          $(".level_name span").remove();
          $(".level_name").addClass("has-error")
          $(".level_name").append("<span class='help-block'>"+msg_level_name+"</span>")
        else
          $(".level_name").removeClass("has-error")
          $(".level_name span").remove();
  
  # 级别信息修改 
  jQuery(document).on "click",".btn-group-sm .update-level", ->
    level_id = $(this).closest(".update-level").attr("data-level-id")
    $.ajax 
      url: "/levels/" + level_id + "/edit",
      method: "get",
      dataType: "html"
    .success (msg) ->
      $( "#level-edit" ).html( msg );
    .error (msg) ->
      console.log(msg)

  jQuery(document).on "submit",".page-levels-edit .simple_form", (event) ->
    values = $( this ).serializeArray()
    console.log(values)
    event.preventDefault();
    $.ajax 
      method: "PATCH",
      url: "/levels/"+values[3].value+"",
      data: $( this ).serializeArray()
    .success ( msg ) ->
      if msg.status is 200 
        $(".level_number").removeClass("has-error")
        $(".level_number span").remove();
        $(".level_name").removeClass("has-error")
        $(".level_name span").remove();
        $('#myEditModal').modal('hide');
        location.reload();
    .error (msg) ->
      msg_level_number = msg.responseJSON.number
      msg_level_name = msg.responseJSON.name 
      if msg.status is 413 
        if msg_level_number isnt undefined 
          $(".level_number").removeClass("has-error")
          $(".level_number span").remove();
          $(".level_number").addClass("has-error")
          $(".level_number").append("<span class='help-block'>"+msg_level_number+"</span>")
        else 
           $(".level_number").removeClass("has-error")
           $(".level_number span").remove();

        if msg_level_name isnt undefined 
          $(".level_name").removeClass("has-error")
          $(".level_name span").remove();
          $(".level_name").addClass("has-error")
          $(".level_name").append("<span class='help-block'>"+msg_level_name+"</span>")
        else 
          $(".level_name").removeClass("has-error")
          $(".level_name span").remove();