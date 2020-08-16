# NLLLT
![title_page_image](https://github.com/DeclanClifford/NLLLT/blob/master/Theory/title_page_image.png)
A simple numerical nonlinear aerodynamic model based on lifting line theory. Uses one horseshoe vortex to model a straight rectangular wing of moderate to large aspect ratio.


# Theory behind the model
To see the theory that went into the model please see [Simple, Simple Post-Stall Aerodynamic Model](https://github.com/DeclanClifford/NLLLT/blob/master/Theory/Simple%2C%20Simple%20Post-Stall%20Aerodynamic%20Model.pdf)

# How do I use it?

The code is well documented, but before tyring to figure out how it works reading Simple, [Simple, Simple Post-Stall Aerodynamic Model](https://github.com/DeclanClifford/NLLLT/blob/master/Theory/Simple%2C%20Simple%20Post-Stall%20Aerodynamic%20Model.pdf)
 is a good place to start.

[single_horseshoe_vortex_model.m](https://github.com/DeclanClifford/NLLLT/blob/master/Codes/single_horseshoe_vortex_model.m) is the code to be looking at. It is a function that outputs the lift coefficient and induced drag coefficient of the lifting surface being modelled. For most practical uses of this model, the body forces of the lifting surface, Fx and Fz would be needed. The function can easily be adapted to output these body forces by changing the function's output From [CL, CDi], to [Fx, Fz]. 

[single_horseshoe_vortex_model_plotter.m](https://github.com/DeclanClifford/NLLLT/blob/master/Codes/single_horseshoe_vortex_model_plotter.m) is a sript that outputs two very simple plots and is here for demonstration purposes only. It outputs a plot of lift coefficient vs. angle of attack for several aspect ratios and a plot of the effect of varying aspect ratio on the lift curve slope.

[clsectional.m](https://github.com/DeclanClifford/NLLLT/blob/master/Codes/clsectional.m) is a dependency of [single_horseshoe_vortex_model.m](https://github.com/DeclanClifford/NLLLT/blob/master/Codes/single_horseshoe_vortex_model.m). It calculates a sectional lift coefficient for a given angle of attack which is used by single_horseshoe_vortex_model.m.

[vfil.m](https://github.com/DeclanClifford/NLLLT/blob/master/Codes/vfil.m) is a dependency of [single_horseshoe_vortex_model.m](https://github.com/DeclanClifford/NLLLT/blob/master/Codes/single_horseshoe_vortex_model.m) and calculates the induction of a vortex filament a point. 
