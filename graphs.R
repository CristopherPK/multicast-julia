# b1: array of times from sync_b_multicast
# b2: array of times from async_b_multicast

b1_upper <- mean(b1) + 1.96*(sd(b1)/sqrt(50))
b1_lower <- mean(b1) - 1.96*(sd(b1)/sqrt(50))

b2_upper <- mean(b2) + 1.96*(sd(b2)/sqrt(50))
b2_lower <- mean(b2) - 1.96*(sd(b2)/sqrt(50))

barCenters <- barplot(c(mean(b1),mean(b2)),
                      names.arg = c("Sync_B_multicast","Async_B_multicast"),
                      ylim = c(0,0.003), main = "B-Multicast")

segments(barCenters, c(b1_lower,b2_lower), barCenters, c(b1_upper,b2_upper), lwd = 1.5)

arrows(barCenters, c(b1_lower,b2_lower), barCenters,
       c(b1_upper,b2_upper), lwd = 1.5, angle = 90,
       code = 3, length = 0.05)
