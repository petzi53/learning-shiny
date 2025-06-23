

library(ambient)
noise <- ambient::noise_worley(c(100, 100))

png("noise_plot.png")
plot(as.raster(normalise(noise)))
dev.off()
