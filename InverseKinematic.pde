import java.util.Arrays; 
import java.lang.Math; 

final float _jointMarkerRadius = 20;
final float _lineWidth = 10;
final float _stepValue = 0.00001;
final float _minCantReachDeltaThrs = 0.00001;
final float _minEffectorRange = 1;
final float _minEffectorMovementThreshold = 0.01;
final PVector _jointColor = new PVector(255,255,255);
InverseKinematicsProcessor ik = new InverseKinematicsProcessor(_minEffectorRange, _stepValue);

void setup()
{
  size(720,720);
  ellipseMode(CENTER);
  ik.targetPoint = new PVector(100, 100);
  ik.add(new KinematicJoint(new PVector(80, 0, 0), radians(0), new PVector(0,0,1), true, new PVector(radians(0), radians(90)) ));
  ik.add(new KinematicJoint(new PVector(50, 0, 0), radians(0), new PVector(0,0,1), true, new PVector(radians(-45), radians(20)) ));
  ik.add(new KinematicJoint(new PVector(100, 0, 0), radians(0), new PVector(0,0,1), false, new PVector(radians(0), radians(90)) ));
  ik.add(new KinematicJoint(new PVector(120, 0, 0), radians(0), new PVector(0,0,1), true, new PVector(radians(-60), radians(90)) ));
  ik.endPoint.set(new PVector(300,0,0));
}
  
void draw()
{
  final float deltaEffector = ik.computeKinematics();
  final boolean effectorIsMoving = deltaEffector >= _minEffectorMovementThreshold;
  
  background(0);
  
  pushMatrix();
  translate(360, 360);
  scale(1,-1);
    
  
  drawJoints();
  drawAnchor();
  drawEffector(effectorIsMoving);
  drawTarget();
  drawTargetDistanceInfo(effectorIsMoving);
  
  popMatrix();
}

void mouseDragged()
{
  float grabRadius = 20;
  PMatrix3D view = new PMatrix3D();
  view.translate(-360, 360);
  PVector mouse = new PVector(mouseX-360, -mouseY+360);
  if(mouse.dist(ik.targetPoint) < grabRadius)
  {
    ik.targetPoint.set(mouse);
  }
}

void drawAnchor()
{
  fill(255);
  noStroke();
  ellipse(0, 0, _jointMarkerRadius, _jointMarkerRadius);
}

void drawJoints()
{
  strokeWeight(_lineWidth);
  PMatrix3D c = new PMatrix3D();
  for(KinematicJoint joint : ik)
  { 
    PVector jointStart = c.mult(new PVector(0,0,0), null);
    c.set(joint.matrix);
    PVector jointEnd = c.mult(new PVector(0,0,0), null);
    fill(_jointColor.x, _jointColor.y, _jointColor.z,128);
    noStroke();
    ellipse(jointStart.x, jointStart.y, _jointMarkerRadius, _jointMarkerRadius);
    stroke(_jointColor.x, _jointColor.y, _jointColor.z, 128);
    line(jointStart.x, jointStart.y, jointEnd.x, jointEnd.y);
  }
}

void drawEffector(boolean effectorIsMoving)
{
  strokeWeight(_lineWidth*0.1);
  if(ik.isInRange)
  {
    noStroke();
    fill(0,255,0);
  } 
  else if(!effectorIsMoving)
  {
    stroke(255,0,0);
    fill(255,0,0, 128);
  }
  else 
  {
    stroke(0,255,0);
    noFill();
  }
  ellipse(ik.endPoint.x, ik.endPoint.y, _jointMarkerRadius, _jointMarkerRadius);
}

void drawTarget()
{
  noStroke();
  fill(128,128,255);
  ellipse(ik.targetPoint.x, ik.targetPoint.y, _jointMarkerRadius, _jointMarkerRadius);
}

void drawTargetDistanceInfo(boolean effectorIsMoving)
{
  if(!effectorIsMoving && !ik.isInRange)
  {
    stroke(255,0,0,128);
    fill(255,0,0);
  }
  else
  {
    stroke(0,255,255,128);
    fill(0,255,255);
  }
  line(ik.targetPoint.x, ik.targetPoint.y, ik.endPoint.x, ik.endPoint.y);
  pushMatrix();
  scale(1,-1);
  text(ik.targetPoint.dist(ik.endPoint) ,(ik.targetPoint.x + ik.endPoint.x)/2.0, -(ik.targetPoint.y + ik.endPoint.y)/2.0); 
  popMatrix();
}
