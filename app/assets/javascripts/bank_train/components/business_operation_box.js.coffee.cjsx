BusinessOperationBox = React.createClass
  getInitialState: ->
    data: []

  componentDidMount: ->
    @load_data_from_server()

  load_data_from_server: ->
    jQuery.ajax
      url: @props.url
      data:
        filter: @props.filter
      dataType: 'json'
      success: (data)=>
        @setState data: data

  _get_children_by_filter: (operations)->
    children = []
    for child in operations
      if child.id == @props.filter
        children.push child
        @_get_children_r(child, operations)
    children

  _get_children_r: (oper, operations)->
    children = @_get_children(oper, operations)
    oper.children = children if oper != null
    for child in children
      @_get_children_r(child, operations)
    children

  _get_children: (parent, operations)->
    children = []
    parent_id = if parent == null then "" else parent.id
    for oper in operations
      if oper.parent_id == parent_id
        children.push oper
    children

  render: ->
    if @props.filter == undefined
      root_operations = @_get_children_r(null, this.state.data)
    else
      root_operations = @_get_children_by_filter(this.state.data)
    <BusinessOperationUl operations={root_operations}/>

BusinessOperationLi = React.createClass
  render: ->
    <li className="operation">
      <div className="name">{this.props.operation.name}</div>
      <a href="/business_operations/#{this.props.operation.id}"  data-confirm="确认删除吗？" data-method="delete">删除</a>
      <a href="/business_operations/#{this.props.operation.id}/edit">修改</a>
      <BusinessOperationUl operations={this.props.operation.children}/>
    </li>

BusinessOperationUl = React.createClass
  render: ->
    <ul className="operations">
      {
        jQuery.map @props.operations, (operation)->
          <BusinessOperationLi key={operation.id} operation={operation} />
      }
    </ul>


jQuery(document).on 'page:change', ->
  $dom = jQuery(".page-business-operations-index .business-operations-tree .tree")
  if $dom.length > 0
    filter = $dom.data("filter")
    dom = $dom.get(0)
    React.render <BusinessOperationBox url="/business_operations.json" filter={filter} />, dom
