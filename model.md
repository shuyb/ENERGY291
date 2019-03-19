Minimize:
$$
\sum_{s\in SOURCE}Cost_s\times\sum_{t\in{TIMESTEP}}Generation_{s,t}\times Coef_{s,t}[\$]
$$
Subject to:
$$
\begin{align}
&\forall s\in \text{Renewables excluding solar and hydro},Coef_{s,t} = 1\\
&\forall s\in \text{Base load source},Coef_{s,t} = Coef_{s,t+1}\geq0\\
&\forall s\in \text{Load following source},Coef_{s,t}\geq0\\
&\forall s= \text{Solar},Coef_{s,t}=\text{Scale of solar}\\
&\forall s\in \text{Hydro sources}, Coef_{s,t}\times Generation_{s,t}\leq\overline{Generation_{s}}\\
&\forall t\in TIMESTEP, \sum_{s\in{SOURCE}}Generation_{s,t}\times Coef_{s,t}=\sum_{s\in{SOURCE}}Generation_{s,t}
\end{align}
$$
where,
$$
\begin{align}
&Generation:\text{Original generation data from the database}\\
&New~Generation:\text{Original generation data with solar generation replaced with our input}\\
&Scale~of~solar:\text{The fraction of solar generation to be deployed over all solar potential}
\end{align}
$$
---

Minimize:
$$
\sum_{b\in{BUSES},t\in TIMESTEP}Discharge\times LCOS+\sum_{b\in{BUSES},t\in TIMESTEP}Peaker\times LCOE[\$]
$$
Subject to:
$$
\begin{align}
&\forall b\in BUSES,t\in TIMESTEP, Discharge_{b,t}\leq\overline{Discharge_b}\\
&\forall b\in BUSES,t\in TIMESTEP, Charge_{b,t}\leq\overline{Charge_b}\\
&\forall b\in BUSES,t\in TIMESTEP, Storage_{b,t}\leq\overline{Storage_b}\\
&\forall b\in BUSES,t\in TIMESTEP, t>1, Storage_{b,t}=Storage_{b,t-1}+Charge_{b,t}-Discharge_{b,t}\\
&\forall b\in BUSES,t\in TIMESTEP,Transmission_{\rightarrow b,t}\leq Generation_{b,t}+Discharge_{b,t}+Peaker_{b,t}\\
&\forall b\in BUSES,t\in TIMESTEP,\\
&Discharge_{b,t}+Generation_{b,t}+Peaker_{b,t}+(1-Loss)\times Transmission_{\rightarrow b,t}\geq\\
&Charge_{b,t}+Load_{b,t}+Transmission_{b\rightarrow,t}
\end{align}
$$

