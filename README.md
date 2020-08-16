# NLLLT
A simple numerical nonlinear aerodynamic model based on lifting line theory. This model uses one horseshoe vortex to model a straight rectangular wing of moderate to large aspect ratio.

# Theory behind the model
To see the theory that went into the model please see the ....pdf

# How do I use it?

single_horseshoe_vortex_model.m is the meat and bones of this project. It outputs the lift coefficient and induced drag coefficient of the lifting surface being modelled. For most practical uses of this model, the body forces of the lifting surface, Fx and Fz would be needed. The function can easily be dapted to output these body forces by simply changing the code's output From [CL, CDi], to [Fx, Fz]. 

single_horseshoe_vortex_model_plotter.m outputs two very simple plots and is here for demonstration purposes only. It outputs a plot of lift coefficient vs. angle of attack for several aspect ratios and a plot of the effect of varying aspect ratio on the lift curve slope.

clsectional.m is a dependency of single_horseshoe_vortex_model.m. It calculates a sectional lift coefficient for a given angle of attack which is used by single_horseshoe_vortex_model.m.

vfil.m is a dependency of single_horseshoe_vortex_model.m and calculates the induction of a vortex filament a point. 
