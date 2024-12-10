diode.data <- read.csv("data.csv")
diode.selected <- diode.data[diode.data$Vdetapprox >= 2.399,]
logIerr <- diode.selected$errIdet/diode.selected$Idetapprox
diode.lm <- lm(log(Idetapprox) ~ Vdetapprox, data=diode.selected,
                                             weights=1/logIerr^2)
summary(diode.lm)

l <- length(diode.selected$Vdetapprox)
d <- 1
while (abs(d - 2) > .5) {
    l = l - 1
    diode.sel_thresh = tail(diode.selected, l)
    diode.lm_threshold <- lm(Idetapprox ~ Vdetapprox,
                             data=diode.sel_thresh)
    r = diode.lm_threshold$residuals
    SSR = sum(diode.lm_threshold$residuals^2)
    DW_sum = sum((r[2:length(r)] - r[1:length(r)-1])^2)
    d = DW_sum / SSR
}

summary(diode.lm_threshold)
