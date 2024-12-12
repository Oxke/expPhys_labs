diode.data <- read.csv("data.csv")
diode.selected <- diode.data[diode.data$Vdetapprox >= 2.399,]
logIerr <- diode.selected$errIdet/diode.selected$Idetapprox
diode.lm <- lm(log(Idetapprox) ~ Vdetapprox, data=diode.selected,
                                             weights=1/logIerr^2)
summary(diode.lm)

l <- length(diode.selected$Vdetapprox)+1
pval <- 0
while (pval < 0.05) {
    l = l - 1
    diode.sel_thresh <- tail(diode.selected, l)
    diode.lm_threshold <- lm(Idetapprox ~ Vdetapprox,
                             data=diode.sel_thresh)
    r = diode.lm_threshold$residuals
    chisq <- sum(r^2 / abs(diode.lm_threshold$fitted.values))
    pval <- pchisq(chisq, l - 2, lower.tail=FALSE)
}
summary(diode.lm_threshold)

res <- exp(diode.lm$fitted.values) - diode.selected$Idetapprox
chisq <- sum(res^2 / var(res)) # assume homoscedasticity
df <- length(diode.lm$residuals) - length(diode.lm$coefficients)
pval <- pchisq(chisq, df, lower.tail=FALSE)
pval
