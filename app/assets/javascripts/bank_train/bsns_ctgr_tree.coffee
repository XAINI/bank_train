class BsnsCtgr
  constructor: (@$elm)->
    @bind_events()
  get_tree = ()->
    [
      {
        text: 'Parent 1'
        c_id: 123
        nodes: [
          {
            text: 'Child 1'
            nodes: [
              { text: 'Grandchild 1' }
              { text: 'Grandchild 2' }
            ]
          }
          { text: 'Child 2' }
        ]
      }
      { text: 'Parent 2' }
      { text: 'Parent 3' }
      { text: 'Parent 4' }
      { text: 'Parent 5' }
    ]
  bind_events: ->
    window.tree = jQuery('.tree').treeview
    data: get_tree()
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
    jQuery.map(tree.treeview('getChecked', 0),(n) -> return n.c_id)

jQuery(document).on 'ready page:load', ->
  if $(".post-business-categories-tree").lengt >  0
    window.ctgr.tree = new BsnsCtgr $(".post-business-categories-tree")