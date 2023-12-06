# 导入所需的库
import numpy as np
import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures
from sklearn.metrics import mean_squared_error
import matplotlib.pyplot as plt

# 读取数据
data = pd.DataFrame({
    'Da': [0.01071146] * 16,
    'pi1': [0.773642146] * 16,
    'pi2': [30.80812499] * 16,
    'pi3': [18.48487499, 21.56568749, 24.64649999, 27.72731249] * 4,
    'pi4': [14.81381528, 15.60813099, 17.02189929, 20.07908304] * 4,
    'tau': [2.665203526, 1.922587416, 1.882459704, 0.895623805,
            2.51597264, 1.776643609, 1.951817932, 1.120144544,
            2.570396819, 2.03735129, 2.330471272, 0.853565629,
            1.123478926, 1.239714001, 0.999587823, 0.693759693],
    'zp': [1.295853606, 2.021824298, 3.419225248, 7.220838643,
           0.96097009, 1.581047437, 2.774617209, 6.021710204,
           0.480485045, 0.948628462, 1.849744806, 4.301221574,
           0.316209487, 0.924872403, 2.580732945, 0.860244315]
})

# 定义 RelativeShear 函数
def RelativeShear(Da, pis, tau, exps, coef):
    tau_max = 1000 * 9.8 * Da * coef * pis[:, 0]**exps[0] * pis[:, 1]**exps[1] * pis[:, 2]**exps[2] * pis[:, 3]**exps[3]
    return np.clip(tau / tau_max, 0, 1)  # 保证 tauRel 小于等于 1

# 提取数据列
Da = data['Da'].values
pis = data[['pi1', 'pi2', 'pi3', 'pi4']].values
tau = data['tau'].values
zp = data['zp'].values.reshape(-1, 1)  # 作为自变量

# 多项式特征转换
degree = 2
poly = PolynomialFeatures(degree=degree)
zp_poly = poly.fit_transform(zp)

# 创建并拟合模型
model = LinearRegression()
model.fit(zp_poly, tau)

# 预测
tau_pred = model.predict(zp_poly)

# 计算均方误差
mse = mean_squared_error(tau, tau_pred)

# 绘图
plt.scatter(zp, tau, color='blue', label='Actual Data')
plt.scatter(zp, tau_pred, color='red', label='Predicted Data')
plt.xlabel('zp')
plt.ylabel('tauRel')
plt.title('Predicted tauRel vs. Actual tauRel')
plt.legend()
plt.grid(True)
plt.show()

# 保存模型系数和截距
coefficients = model.coef_
intercept = model.intercept_

# 输出模型系数
print("Model intercept:", intercept)
print("Model coefficients:", coefficients)
print("Mean Squared Error:", mse)

