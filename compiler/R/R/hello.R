# read files
students <- read.csv("HW2-Student-Main.csv", header = FALSE, col.names = c("ID", "Name", "Type"))
fees <- read.csv("HW2-Fees.csv", header = FALSE, col.names = c("Type", "Fee"))
payments <- read.csv("HW2-Student-Payment.csv", header = FALSE, col.names = c("ID", "Amount"))

# make sure data types are right
students$ID <- as.character(students$ID)
payments$ID <- as.character(payments$ID)
payments$Amount <- as.numeric(payments$Amount)
fees$Fee <- as.numeric(fees$Fee)

# if a student have more than one payment data, add them
total_payments <- aggregate(Amount ~ ID, data = payments, sum)

# based on the payment type, combine the student data and how much should they pay
students <- merge(students, fees, by = "Type", all.x = TRUE)

# combine student data and how much they already paid
students <- merge(students, total_payments, by = "ID", all.x = TRUE)

# 把 NA（沒繳費）補 0
students$Amount[is.na(students$Amount)] <- 0

# calculate arrears
students$Due <- students$Fee - students$Amount

# display list
due_students <- subset(students, Due > 0)

cat("====== List ======\n")
for (i in seq_len(nrow(due_students))) {
  s <- due_students[i, ]
  cat("ID   :", s$ID, "\n")
  cat("Name :", s$Name, "\n")
  cat("Type :", s$Type, "\n")
  cat("Fee  :", s$Fee, "\n")
  cat("Paid :", s$Amount, "\n")
  cat("Due  :", s$Due, "\n")
  cat("------------------------\n")
}

# display total payment
total_received <- sum(students$Amount)
cat("====================================\n")
cat("TOTAL RECEIVED BEFORE DUE:", total_received, "\n")
cat("====================================\n")

