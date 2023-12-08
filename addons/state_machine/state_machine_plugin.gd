@tool
extends EditorPlugin
# TODO: Make a Control for the Bottom Panel for setting up StateMachines

const STATE_COMPONENT_FILTER : String = \
	"EnterCallFunctionStateComponent,
	EnterCallFunctionVariableStateComponent,
	ResumeCallFunctionStateComponent,
	ResumeCallFunctionVariableStateComponent,
	UpdateCallFunctionStateComponent,
	UpdateCallFunctionVariableStateComponent,
	EqualsTransitionStateComponent,
	NotEqualsTransitionStateComponent,
	GreaterThanTransitionStateComponent,
	LessThanTransitionStateComponent,
	ExitCallFunctionStateComponent,
	ExitCallFunctionVariableStateComponent,
	FunctionActivationStateComponent,
	DelayedActivationStateComponent,
	TransitionStateComponent,
	ReleasedTransitionStateComponent,
	PressedTransitionStateComponent,
	AnimationFinishedStateComponent"


func _enter_tree():
	var editor_tree : SceneTree = EditorInterface.get_inspector().get_tree()
	editor_tree.node_added.connect(_on_node_added)


func _exit_tree():
	return


func _on_node_added(node : Node):
	if node is EditorResourcePicker:
		var base_types : PackedStringArray = node.base_type.split(",", false) 
		if base_types.has("StateComponent"):
			node.base_type = STATE_COMPONENT_FILTER
