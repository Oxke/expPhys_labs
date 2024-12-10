diode.data <- read.csv("data.csv")
diode.selected <- diode.data[diode.data$Vdetapprox >= 2.399,]
logIerr <- diode.selected$errIdet/diode.selected$Idetapprox
diode.lm <- lm(log(Idetapprox) ~ Vdetapprox, data=diode.selected,
                                             weights=1/logIerr^2)
summary(diode.lm)
