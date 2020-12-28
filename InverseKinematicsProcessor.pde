import java.util.ArrayList;

/**
* Class in charge of computing the inverse kinematics
* of its sequence of KinematicJoint from a target point.
* @see KinematicJoint.
*/
public class InverseKinematicsProcessor extends ArrayList<KinematicJoint>
{  
  /**
  * The target point to reach.
  */
  public PVector targetPoint;
  
  /**
  * The minimal distance between #targetPoint and #endPoint
  * to consider the goal reached.
  */
  public float range;
  
  /**
  * The multiplier to apply to the computed deltas.
  */
  public float stepValueMultiplier;
  
  /**
  * Whether or not the #endPoint is within #range of #targetPoint.
  */
  public boolean isInRange;
  
  /**
  * The current kinematic joint chain's end point.
  */
  public PVector endPoint;
  
  
  
  /**
  * Default constructor. Initializes the #range to range
  * @param range  The default required minimal range.
  * @param stepValueMultiplier  The multiplier for the size of the 
  *                             steps taken each iteration.
  */
  public InverseKinematicsProcessor(float range, float stepValueMultiplier)
  {
    this.range = range;
    this.stepValueMultiplier = stepValueMultiplier;
    this.isInRange = false;
    this.targetPoint = new PVector();
    this.endPoint = new PVector();
  }
  
  /**
  * Moves the kinematic joint chain towards the #targetPoint.
  * @return  The distance the #endPoint moved.
  */
  float computeKinematics()
  {
    PVector oldEndPoint = this.endPoint.copy();
    this.isInRange = (getDistanceToTarget() <= this.range);
    
    if(!this.isInRange)
    {
      // compute joint transformations
      PMatrix3D cumul = new PMatrix3D();
      for(KinematicJoint joint: this)
      {
        cumul.apply(joint.getLocalTransformationMatrix());
        joint.matrix.set(cumul);
      }
      this.endPoint = cumul.mult(new PVector(), null);
      Vector deltaOrientations = getDeltaOrientation();
      
      int i = 0;
      for(KinematicJoint joint : this)
      {
        float delta = deltaOrientations.data[i++] * this.stepValueMultiplier;
        if(joint.isAngleConstrained)
        {
          joint.angle = constrain(
            joint.angle + delta, 
            joint.angleConstraints.x, 
            joint.angleConstraints.y);
        }
        else
        {
          joint.angle += delta;
        }
      }
    }
    return this.endPoint.dist(oldEndPoint);
  }
  
  /**
  * Gets the distance between the #endPoint and the #targetPoint.
  * @return  The distance between the #endPoint and the #targetPoint.
  */
  public float getDistanceToTarget()
  {
     return this.endPoint.dist(this.targetPoint);
  }

  /**
  * Gets the delta value towards the #targetPoint for each joint.
  * @return  The delta value towards the #targetPoint for each joint.
  */
  Vector getDeltaOrientation()
  {
     Matrix jT = getJacobianTranspose();
     PVector dist = new PVector(
       this.targetPoint.x - this.endPoint.x,
       this.targetPoint.y - this.endPoint.y,
       this.targetPoint.z - this.endPoint.z
     );
     Vector v = new Vector(dist);
     return  jT.multV(v);
  }
  
  /**
  * Gets the transposed jacobian matrix of the kinematic joints transformation.
  * @return  The transposed jacobian matrix of the kinematic joints transformation.
  */
  Matrix getJacobianTranspose()
  {
     Matrix jacobian = new Matrix(3, size()); // endpoint vector is size 3
     PMatrix3D currentMatrix = new PMatrix3D();
     int i = 0;
     for(KinematicJoint joint: this)
     {
       PVector jointEndPoint = currentMatrix.mult(new PVector(0,0,0), null);
       PVector pv = new PVector(
         this.endPoint.x - jointEndPoint.x,
         this.endPoint.y - jointEndPoint.y,
         this.endPoint.z - jointEndPoint.z
       );
       PVector jointJacobian = joint.angleAxis.cross(pv);     
       Vector jointJac = new Vector(jointJacobian);
       jacobian.setCol(i++, jointJac);
       currentMatrix.set(joint.matrix);
     }
     jacobian.transpose();
     return jacobian;
  }
};
