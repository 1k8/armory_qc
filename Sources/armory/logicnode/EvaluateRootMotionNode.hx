package armory.logicnode;

import iron.object.BoneAnimation;
import iron.object.Object;
import iron.math.Mat4;

class EvaluateRootMotionNode extends LogicNode {

    #if arm_skin
    var object: Object;
    var animation: BoneAnimation;
    var ready = false;
    #end


	public function new(tree: LogicTree) {
		super(tree);
	}

    #if arm_skin
    public function init(){
		object = inputs[1].get();
		assert(Error, object != null, "The object input not be null");
		animation = object.getParentArmature(object.name);
        assert(Error, animation != null, "The object does not have an Armature action");
		ready = true;
	}

	override function run(from: Int) {

        if(! ready) init();
        var boneName: String = inputs[3].get();
        var bone = animation.getBone(boneName);
        assert(Error, bone != null, "Bone does not exist");
        animation.setRootMotion(bone);
    }

    override function get(from:Int):Dynamic {
        if(! ready) init();

        if(animation.getRootMotionBone() == null) run(0);

        return function (animMats: Array<Mat4>) {
            var boneName: String = inputs[3].get();
            animation.evaluateRootMotion(boneName, inputs[2].get()(animMats));
        };
    }

    #end
}