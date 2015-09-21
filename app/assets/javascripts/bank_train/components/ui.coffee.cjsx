jQuery(document).on 'page:change', ->
  modify = ($item, key, idx)->
    $item.find('input').attr 'name', "foobar[#{idx}]"
    $item.find('.input-group-addon').text idx + 1

  if jQuery('.demo-inputer').length
    React.render (
      <AddableItemsInputer modify={modify}>
        <div className='input-group'>
          <span className='input-group-addon'></span>
          <input type='text' className='form-control input-sm' placeholder='请输入……' />
          <span className='input-group-btn'>
            <a className='btn btn-default btn-sm' href='javascript:;' role='remove-btn'>
              <span className='glyphicon glyphicon-trash'></span>
              <span>删除</span>
            </a>
          </span>
        </div>
      </AddableItemsInputer>
    ), jQuery('.demo-inputer')[0]