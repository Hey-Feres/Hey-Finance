class HomeController < ApplicationController
  def index
 	@transactions = Transaction.all.order("random()")
	despesas = Transaction.where(kind: "Despesa").map{|d| d.value}.sum.to_f
	receitas = Transaction.where(kind: "Receita").map{|d| d.value}.sum.to_f
  	@saldo = receitas - despesas 
  	charts
  	analytics
  end
 
  def save_transaction
  	transaction = Transaction.create!(
  		kind: params[:kind],
		title: params[:title],
		value: params[:value],
		group: params[:group]
  	)
  	if transaction.save
  		redirect_to root_path, notice: "Adicionado com sucesso" 
  	end
  end

  def analytics
	#grm = gasto vs receitas mensais
	despesas = Transaction.where(kind: "Despesa").map{|x| x.value}.sum.to_f
	receitas = Transaction.where(kind: "Receita").map{|x| x.value}.sum.to_f

	@porcentagem = (despesas * 100) / receitas
  end

  def charts
	despesas = Transaction.where(kind: "Despesa").group_by{|m| m.created_at.beginning_of_month}.map{|m,n| {"month" => m.strftime("%B"), "value" => n.map{|n| n.value}.sum.to_f}}
	receitas = Transaction.where(kind: "Receita").group_by{|m| m.created_at.beginning_of_month}.map{|m,n| {"month" => m.strftime("%B"), "value" => n.map{|n| n.value}.sum.to_f}}
	despesas_categorias = Transaction.where(kind: "Despesa").group_by{|d| d.group}.map{|m,n| {"group" => m, "value" => n.map{|n| n.value}.sum.to_f}}

	@data_despesas_vs_receitas = {
	  labels: despesas.map{|d| d["month"]},
	  datasets: [
	    {
	        label: "Despesas",
	        backgroundColor: "rgba(255, 150, 150,0.2)",
	        borderColor: "red",
	        data: despesas.map{|d| d["value"]}
	    },
	    {
	        label: "Receitas",
	        backgroundColor: "rgba(140, 250, 169,0.2)",
	        borderColor: "green",
	        data: receitas.map{|d| d["value"]}
	    }	    

	  ]
	}

	@data_despesas = {
	  labels: despesas.map{|d| d["month"]},
	  datasets: [
	    {
	        label: "Despesas",
	        backgroundColor: "rgba(255, 150, 150,0.2)",
	        borderColor: "red",
	        data: despesas.map{|d| d["value"]}
	    }
	  ]
	}
	
	@data_receitas = {
	  labels: receitas.map{|d| d["month"]},
	  datasets: [
	    {
	        label: "Receitas",
	        backgroundColor: "rgba(140, 250, 169,0.2)",
	        borderColor: "green",
	        data: receitas.map{|d| d["value"]}
	    }
	  ]
	}	

	@data_despesas_categorias = {
	  labels: despesas_categorias.map{|d| d["group"]},
	  datasets: [
	    {
	        label: "Receitas",
	        backgroundColor: ["#0e0e52", "#150578", "#449dd1", "#3943b7", "#78c0e0"],
	        borderColor: "#666",
	        data: despesas_categorias.map{|d| d["value"]}
	    }
	  ]
	}	

  end
end

#ubuntu@ubuntu:~/Ruby/finance$ rails g model Transaction kind title value:decimal group
#100.times do |i| Transaction.create!(kind: "Despesa",title: "Teste",value: rand(10..1000),group: groups[rand(0..3)]) end
#50.times do |i| Transaction.create!(kind: "Receita",title: "Teste",value: rand(1000..5000),group: "Remuneracao") end
