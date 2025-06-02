import os
import time
import csv
import pandas as pd
from tqdm import tqdm
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# === PATHS ===
INPUT_CSV = "/Users/chiphan/Documents/Chi/1-Learning/2025-Spring/COMP4010-DataViz/Assignment/Project/Project-2/toxic-ddi-visualization/data/toxicity_ddi_normalized.csv"
OUTPUT_CSV = "/Users/chiphan/Documents/Chi/1-Learning/2025-Spring/COMP4010-DataViz/Assignment/Project/Project-2/toxic-ddi-visualization/data/ddi_with_ddinter_info.csv"

def init_driver():
    options = Options()
    options.add_argument("--ignore-certificate-errors")
    options.add_argument("--headless")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    return webdriver.Chrome(options=options)

def add_drug(driver, drug_name):
    input_box = driver.find_element(By.XPATH, '//input[@placeholder="Enter a drug name"]')
    input_box.clear()
    input_box.send_keys(drug_name)
    input_box.click()
    time.sleep(0.7)

    try:
        dropdown_option = WebDriverWait(driver, 7).until(
            EC.presence_of_element_located((By.XPATH, f'//li[contains(text(), "{drug_name}")]'))
        )
        dropdown_option.click()
        time.sleep(0.5)
    except:
        pass  # skip if not found

def click_get_interactions(driver):
    try:
        WebDriverWait(driver, 10).until(
            EC.presence_of_all_elements_located((By.CSS_SELECTOR, "#label-block-parent .drug-label"))
        )
        button = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((By.ID, "get_interactions"))
        )
        driver.execute_script("arguments[0].scrollIntoView(true);", button)
        time.sleep(0.5)
        ActionChains(driver).move_to_element(button).pause(0.3).click(button).perform()
        time.sleep(2)
        if len(driver.window_handles) > 1:
            driver.switch_to.window(driver.window_handles[-1])
    except:
        pass

def extract_ddinter_info(driver, drug1, drug2):
    try:
        driver.get("https://ddinter2.scbdd.com/inter-checker/")
        time.sleep(2)
        add_drug(driver, drug1)
        add_drug(driver, drug2)
        click_get_interactions(driver)

        if len(driver.window_handles) > 1:
            driver.switch_to.window(driver.window_handles[-1])
            time.sleep(1)

        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CLASS_NAME, "result-interaction-item"))
        )

        try:
            severity = driver.find_element(By.CSS_SELECTOR, "span.badge").text.strip()
        except:
            severity = None
        try:
            interaction = driver.find_element(By.CLASS_NAME, "result-interaction-item").text.strip().replace("Interaction: ", "")
        except:
            interaction = None
        try:
            management = driver.find_element(By.CLASS_NAME, "result-management-item").text.strip().replace("Management: ", "")
        except:
            management = None

        driver.close()
        driver.switch_to.window(driver.window_handles[0])
        return severity, interaction, management
    except:
        return None, None, None

def main():
    df = pd.read_csv(INPUT_CSV).head(1000)

    # Initialize CSV if not exists
    if not os.path.exists(OUTPUT_CSV):
        with open(OUTPUT_CSV, "w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow([
                "drug1_id", "drug2_id", "drug1_name", "drug2_name",
                "interaction_type", "matched_toxicity_types", "interaction_type_normalized",
                "ddinter_severity", "ddinter_interaction", "ddinter_management"
            ])

    driver = init_driver()

    for _, row in tqdm(df.iterrows(), total=len(df), desc="Crawling DDInter"):
        drug1 = row["drug1_name"]
        drug2 = row["drug2_name"]
        severity, interaction, management = extract_ddinter_info(driver, drug1, drug2)

        result = [
            row["drug1_id"], row["drug2_id"], drug1, drug2,
            row.get("interaction_type", ""),
            row.get("matched_toxicity_types", ""),
            row.get("interaction_type_normalized", ""),
            severity, interaction, management
        ]

        with open(OUTPUT_CSV, "a", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow(result)

    driver.quit()
    print(f"Done. Results saved to: {OUTPUT_CSV}")

if __name__ == "__main__":
    main()