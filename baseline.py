import pandas as pd
import random

reviews_df = pd.read_csv("bgg-15m-reviews.csv")
reviews_df = reviews_df[["ID","comment", "rating"]]
reviews_df.head()


#Rounding, otherwise it will be impossible to actually guess the reviews
rounded_ratings = reviews_df["rating"].round(0)
reviews_df["rating"] = rounded_ratings
print(reviews_df["rating"].mode())
print(reviews_df["rating"].value_counts())
print(len(reviews_df))

m_correct=0
s_correct=0
r_correct=0
s_probs={8:.275, 7:.244, 6:.193, 9:.098, 5:.07, 10:.055, 4:.036, 3:.017, 2:.008, 1:.004}
for rating in reviews_df["rating"]:
    random_guess = random.randint(0,10)
    strat_guess = random.choices(list(s_probs.keys()), list(s_probs.values()))
    strat_guess = strat_guess[0]
    if rating == 8:
        m_correct+=1
    elif rating == strat_guess:
        s_correct+=1
    elif rating==random_guess:
        r_correct+=1
print(f"Random Accuracy: {r_correct/len(reviews_df)}")
print(f"Stratified Accuracy: {s_correct/len(reviews_df)}")
print(f"Majority Accuracy: {m_correct/len(reviews_df)}")

