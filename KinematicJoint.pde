/**
* Class representing a kinematic joint. Kinematic joints are
* a structure of a given size (possessing origin and end points)
* and able to either rotate around its origin, extend along its
* length or both.
*/
public class KinematicJoint
{
  /**
  * The position of the end of the joint relative to its origin.
  */
  public PVector size;
  
  /**
  * The angle of rotation of the joint around the @see #angleAxis going 
  * through the joint's origin.
  */
  public float angle;
  
  /**
  * The axis of rotation from the origin of the joint.
  */
  public PVector angleAxis;
  
  /**
  *  Whether or not the joint is rotationally constrained.
  */
  public boolean isAngleConstrained;
  
  /**
  * The rotation angle constraints value stored in X (min) and Y (max).
  */
  public PVector angleConstraints;
  
  /**
  * The world transformation matrix of the joint.
  */ 
  public PMatrix3D matrix;
  
  /**
  * Constructor. Initializes #size, #angle, #angleAxis, #isAngleConstrained 
  * and #angleConstraints to the given values and #matrix to the Identity
  * matrix.
  * @param size  The position of the end of the joint relative to its origin.
  * @param angle  The angle of rotation of the joint around the @see  
  *               #angleAxis going through the joint's origin.
  * @param angleAxis  The axis of rotation from the origin of the joint.
  * @param isAngleConstrained  Whether or not the joint is rotationally 
  *                            constrained.
  * @param angleConstraints The rotation angle constraints value stored in X 
  *                         (min) and Y (max).
  */
  public KinematicJoint(PVector size, float angle, PVector angleAxis, 
      boolean isAngleConstrained, PVector angleConstraints)
  {
    this.size = size;
    this.angle = angle;
    this.angleAxis = angleAxis;
    this.isAngleConstrained = isAngleConstrained;
    this.angleConstraints = angleConstraints;
    this.matrix = new PMatrix3D();
  }
  
  /**
  * Deep copy constructor.
  */
  public KinematicJoint(KinematicJoint other)
  {
    this.size = other.size;
    this.angle = other.angle;
    this.angleAxis = other.angleAxis;
    this.isAngleConstrained = other.isAngleConstrained;
    this.angleConstraints = other.angleConstraints;
    this.matrix = new PMatrix3D(other.matrix);
  }
  
  /**
  * Computes the local transformation of the joint based on its properties.
  * Do not confuse with #matrix, which is used for world transformation
  */
  public PMatrix3D getLocalTransformationMatrix()
  {
     PMatrix3D trans = new PMatrix3D();
     trans.rotate(this.angle, this.angleAxis.x, this.angleAxis.y, this.angleAxis.z);
     trans.translate(this.size.x, this.size.y, this.size.z);
     return trans;
  }
};
