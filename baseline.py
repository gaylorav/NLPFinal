import pandas as pd
import random

descriptions_df = pd.read_csv("bg_descriptions.csv")
descriptions_df.head()


#Rounding, otherwise it will be impossible to actually guess the reviews
ratings = descriptions_df["sentiment"].tolist()
print(descriptions_df["sentiment"].mode())
print(descriptions_df["sentiment"].value_counts())
print(len(descriptions_df))

m_correct=0
s_correct=0
r_correct=0
s_probs={-1:0.2102, 0:0.22, 1:0.5698}
for rating in ratings:
    random_guess = random.randint(-1,1)
    strat_guess = random.choices(list(s_probs.keys()), list(s_probs.values()))
    strat_guess = strat_guess[0]
    if rating == 1:
        m_correct+=1
    elif rating == strat_guess:
        s_correct+=1
    elif rating==random_guess:
        r_correct+=1
print(f"Random Accuracy: {r_correct/len(descriptions_df)}")
print(f"Stratified Accuracy: {s_correct/len(descriptions_df)}")
print(f"Majority Accuracy: {m_correct/len(descriptions_df)}")

