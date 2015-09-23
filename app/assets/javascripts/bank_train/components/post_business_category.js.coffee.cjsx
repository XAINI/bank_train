PostBusinessCategory = React.createClass
  getInitialState: ->
    data: []

  componentDidMount: ->
    @load_data_from_server()

  load_data_from_server: ->
    jQuery.ajax
      url: @props.url
      dataType: 'json'
      success: (data)=>
        @setState data: data

  _get_children_r: (cate, categories)->
    children = @_get_children(cate, categories)
    cate.children = children if cate != null
    for child in children
      @_get_children_r(child, categories)
    children

  _get_children: (parent, categories)->
    children = []
    parent_id = if parent == null then "" else parent.id
    for cate in categories
      if cate.parent_id == parent_id
        children.push cate
    children

  render: ->
    root_categories = @_get_children_r(null, this.state.data)
    <PostBusinessCategoryUl categories={root_categories}/>


PostBusinessCategoryUl = React.createClass
  render: ->
    <ul className="category">
      {
        jQuery.map @props.categories, (category)->
          <PostBusinessCategoryLi key={category.id} category={category} />
      }
    </ul>

PostBusinessCategoryLi = React.createClass
  render: ->
    <li className="categories">
      <div className="name">
        <span>{@props.category.name}</span>
        { if @props.category.children_info != "" then <span>{@props.category.children_info}</span> }
        { if @props.category.posts_info != "" then <span className='posts'>{@props.category.posts_info}</span> }
        { <a href="/business_operations?filter=#{oper.id}">{oper.name}</a> for oper in @props.category.operations }
      </div>
      <a href="/posts/#{@props.category.id}/edit">修改</a>
      <a href="/posts/#{@props.category.id}" data-confirm="是否确认删除？" data-method="delete">删除</a>
      <PostBusinessCategoryUl categories={this.props.category.children}/>
    </li>


jQuery(document).on 'page:change', ->
  dom = jQuery(".post-business-categories-tree .tree").get(0)
  if dom != undefined
    React.render <PostBusinessCategory url="/posts.json"/>, dom
