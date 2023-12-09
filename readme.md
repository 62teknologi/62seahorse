# 62seahorse

62seahorse is a REST API written in Golang designed to manage moderation and can run independly as a stateless service.

The main goal of 62seahorse is to reduce repetition of creating and moderate moderation data.

Created by 62teknologi.com, perfected by Community.

## Moderation
This introduction will help You explain the concept and characteristic of moderation.

## Running 62seahorse

Follow the instruction below to running 62seahorse on Your local machine.

### Prerequisites
Make sure to have preinstalled this prerequisites apps before You continue to installation manual. we don't include how to install these apps below most of this prerequisites is a free apps which You can find the "How to" installation tutorial anywhere in web and different machine OS have different way to install.
- MySql
- Go

# Table Naming Structure

## Normal Tables
Normal tables follow the naming convention of combining the module name and the moderation table name.

Example:
- Module: mod
- Moderation Table: moderation
- Naming: `mod_moderations`

## Pivot Tables
Pivot tables combine the moderation table name with the base table name and base module name.

Example:
- Base Table Module Name: `hr`
- Base Table Name: `expense`
- Moderation Table: moderation
- Naming: `hr_expense_moderations`

## Sequence Tables
Sequence tables include a sequence suffix in addition to the module and moderation table names.

Example:
- Module: mod
- Moderation Table: moderation
- Sequence Suffix: sequence
- Naming: `mod_moderation_sequences`

## User Tables
User tables include the hardcoded term "user" in addition to the module and moderation table names.

Example:
- Module: mod
- Moderation Table: moderation
- Naming: `mod_moderation_users`

This naming structure provides clarity and consistency for different types of tables within the database. Adjust the module, moderation table, and any additional suffixes according to your specific naming needs.


### Installation manual
This installation manual will guide You to running the binary on Your ubuntu or mac terminal.

1. Clone the repository
```
git clone https://github.com/62teknologi/62seahorse
```

1. Change directory to the cloned repository
```
cd 62seahorse
```

1. Initiate the submodule
```
git submodule update --init
```

1. Create .env base on .env.example
```
cp .env.example .env
```

1. Change DB variable on .env using Your mysql configuration or the staging database on cloud server eg
```
HTTP_SERVER_ADDRESS=0.0.0.0:5004
DB_DRIVER=mysql
DB_SOURCE_1=root@tcp(127.0.0.1:3306)/seahorse_local
DB_SOURCE_2=
PREFIX='moderation'
```

1. Build the binary
```
sh ./build.sh
```

1. Run the server
```
go run main.go
```

The API server will start running on `http://localhost:5004`. You can now interact with the API using Your preferred API client or through the command line with `curl`.


# Contributing

If You'd like to contribute to the development of the 62whale REST API, please follow these steps:

1. Fork the repository
2. Create a new branch for Your feature or bugfix
3. Commit Your changes to the branch
4. Create a pull request, describing the changes You've made

We appreciate Your contributions and will review Your pull request as soon as possible.

## Must Preserve Characteristic 
- Reduce repetition
- Easy to use REST API
- Easy to setup
- Easy to Customizable
- high performance
- Robust data validation and error handling
- Well documented API endpoints

## License

This project is licensed under the MIT License. For more information, please see the [LICENSE](./LICENSE) file.

# About 62
**E.nam\Du.a**

Indonesian language; spelling: A-num\Due-wa

Origin: Enam Dua means ‘six-two’ or sixty two. It is Indonesia’s international country code (+62), that was also used as a meme word for “Indonesia” by “Indonesian internet citizen” (netizen) in social media.