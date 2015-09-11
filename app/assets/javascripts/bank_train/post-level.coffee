jQuery(document).on 'ready page:load', ->
  # 新增岗位
  jQuery(".page-posts-form-new").on "submit",".simple_form",(event) ->
    values = $( this ).serializeArray()
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
      if msg.status is 413
        if values[2].value is "" 
          $(".post_number").removeClass("has-error")
          $(".post_number span").remove();
          $(".post_number").addClass("has-error")
          $(".post_number").append("<span class='help-block'>岗位编号不能为空</span>")
        else
           $(".post_number").removeClass("has-error")
           $(".post_number span").remove();

        if values[3].value is "" 
          $(".post_name").removeClass("has-error")
          $(".post_name span").remove();
          $(".post_name").addClass("has-error")
          $(".post_name").append("<span class='help-block'>岗位名不能为空</span>")
        else
          $(".post_name").removeClass("has-error")
          $(".post_name span").remove();
        
  # 岗位信息修改 
  jQuery(document).on "click",".btn-group-sm .update-post", ->
    post_id = $(this).closest(".update-post").attr("id")
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
      if msg.status is 413 
        if values[4].value is "" 
          $(".post_number").removeClass("has-error")
          $(".post_number span").remove();
          $(".post_number").addClass("has-error")
          $(".post_number").append("<span class='help-block'>岗位编号不能为空</span>")
        else 
           $(".post_number").removeClass("has-error")
           $(".post_number span").remove();
         
        if values[5].value is ""
          $(".post_name").removeClass("has-error")
          $(".post_name span").remove();
          $(".post_name").addClass("has-error")
          $(".post_name").append("<span class='help-block'>岗位名不能为空</span>")
        else 
          $(".post_name").removeClass("has-error")
          $(".post_name span").remove();


# 新增级别
  jQuery(".page-levels-new").on "submit",".simple_form", (event) ->
    values = $( this ).serializeArray()
    console.log(values)
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
      if msg.status is 413 
        if values[2].value is ""
          $(".level_number").removeClass("has-error")
          $(".level_number span").remove();
          $(".level_number").addClass("has-error")
          $(".level_number").append("<span class='help-block'>级别编号不能为空</span>")
        else
           $(".level_number").removeClass("has-error")
           $(".level_number span").remove();
        
        if values[3].value is "" 
          $(".level_name").removeClass("has-error")
          $(".level_name span").remove();
          $(".level_name").addClass("has-error")
          $(".level_name").append("<span class='help-block'>级别名称不能为空</span>")
        else
          $(".level_name").removeClass("has-error")
          $(".level_name span").remove();
  
  # 级别信息修改 
  jQuery(document).on "click",".btn-group-sm .update-level", ->
    level_id = $(this).closest(".update-level").attr("id")
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
      if msg.status is 413 
        if values[4].value is "" 
          $(".level_number").removeClass("has-error")
          $(".level_number span").remove();
          $(".level_number").addClass("has-error")
          $(".level_number").append("<span class='help-block'>级别编号不能为空</span>")
        else 
           $(".level_number").removeClass("has-error")
           $(".level_number span").remove();

        if values[5].value is "" 
          $(".level_name").removeClass("has-error")
          $(".level_name span").remove();
          $(".level_name").addClass("has-error")
          $(".level_name").append("<span class='help-block'>级别名称不能为空</span>")
        else 
          $(".level_name").removeClass("has-error")
          $(".level_name span").remove();