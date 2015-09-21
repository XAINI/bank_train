def json_path(fname)
  File.join __dir__, 'init-data', fname
end

def get_json_data(fname)
  json = File.read json_path(fname)
  data = JSON.parse(json)
end

def import_posts
  BankTrain::Post.destroy_all
  get_json_data('categories.json').each do |d|
    BankTrain::Post.create number: d['no'], name: d['name'], desc: d['desc']
  end
end

def import_levels
  BankTrain::Level.destroy_all
  data = get_json_data('levels.json')

  # 导入级别
  data[1].each do |number, name|
    BankTrain::Level.create number: number, name: name
  end

  # 导入级别与岗位关系
  data[2].each do |post_number, level_numbers|
    post = BankTrain::Post.where(number: post_number).first
    levels = level_numbers.map do |ln|
      BankTrain::Level.where(number: ln.to_s).first
    end
    post.levels = levels
  end
end

def import_business_categories
  BankTrain::BusinessCategory.destroy_all
  data = get_json_data('levels.json')

  # 导入业务类型
  data[0].each do |name, children_names|
    bc = BankTrain::BusinessCategory.create name: name
    children = children_names.map do |child_name|
      BankTrain::BusinessCategory.create name: child_name
    end
    bc.children = children
  end

  # 导入业务类型与岗位关系
  data = get_json_data('ywkinds.json')
  data.each do |post_number, category_names|
    post = BankTrain::Post.where(number: post_number).first
    categories = category_names.map do |name|
      BankTrain::BusinessCategory.where(name: name).first
    end
    post.business_categories = categories
  end
end

def _r_ibo(item) # import_business_operations
  name = item['name']
  chapter_number = item['chapter_no']
  number = (item['yw_no']||'').sub('#', '')
  operation = BankTrain::BusinessOperation.create name: name, number: number, chapter_number: chapter_number

  children = (item['children']||[]).map do |citem|
    _r_ibo citem
  end

  operation.children = children
  operation
end

def import_business_operations
  BankTrain::BusinessOperation.destroy_all
  data = get_json_data('index.json')
  data['children'].each do |item|
    _r_ibo item
  end
end

def import_business_relations
  data = get_json_data('levels.json')
  data[3].each do |category_name, operation_names|
    category = BankTrain::BusinessCategory.where(name: category_name).first
    operation = BankTrain::BusinessOperation.where(name: operation_names[0]).first

    category.business_operations = [operation]
  end
end

import_posts
import_levels
import_business_categories
import_business_operations
import_business_relations
