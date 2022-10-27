# metal game

CanBreak game development notes,


- device: reference to the GPU
- 1 device and 1 commandQueue for per APP
- half4 -> smaller float
- MTKViewDelegate calls func draw(in view: MTKView) method 60 times per second
- we must finish encoding all the commands then sent the command buffer to GPU(device)
- MTKViewDelegate calls func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize)  whenever the view size changed, rotating the device etc.
